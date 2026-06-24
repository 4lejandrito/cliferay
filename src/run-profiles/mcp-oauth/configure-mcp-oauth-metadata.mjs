#!/usr/bin/env node
import {execSync} from 'node:child_process';
import {createRequire} from 'node:module';

let chromium;
try {
	const globalRoot = execSync('npm root -g', {encoding: 'utf8'}).trim();
	({chromium} = createRequire(`${globalRoot}/resolver.cjs`)('playwright'));
} catch {
	console.error('Playwright not found. Install it globally first:');
	console.error('  npm i -g playwright && playwright install chromium');
	process.exit(1);
}

const BASE = (process.env.LIFERAY_URL || 'http://localhost:8080').replace(/\/+$/, '');
const USER = process.env.LIFERAY_USER || 'test@liferay.com';
const PASSWORD = process.env.LIFERAY_PASSWORD || 'test';
const ISSUER = (process.env.LIFERAY_ISSUER || BASE).replace(/\/+$/, '');
const HEADLESS = process.env.HEADLESS !== 'false';

const SCOPES = 'Liferay.OAuth.Client.REST.everything,Liferay.MCP.Server.everything';

const PORTLET = 'com_liferay_oauth_client_admin_web_internal_portlet_OAuthClientAdminPortlet';
const NS = `_${PORTLET}_`;

function manageURL(mvcRenderCommandName, params = {}) {
	const url = new URL(`${BASE}/group/control_panel/manage`);
	url.searchParams.set('p_p_id', PORTLET);
	url.searchParams.set('p_p_lifecycle', '0');
	url.searchParams.set('p_p_state', 'maximized');
	url.searchParams.set('p_p_mode', 'view');
	url.searchParams.set(`${NS}mvcRenderCommandName`, mvcRenderCommandName);
	for (const [key, value] of Object.entries(params)) {
		url.searchParams.set(`${NS}${key}`, value);
	}
	return url.toString();
}

async function set(page, field, value) {
	await page.locator(`#${NS}${field}`).fill(value);
}

async function check(page, field) {
	await page.locator(`#${NS}${field}`).check();
}

async function save(page) {
	await page.getByRole('button', {name: 'Save', exact: true}).click();
	await page.waitForLoadState('networkidle');

	const alert = page.locator('.alert-danger');
	if (await alert.count()) {
		const text = (await alert.first().innerText()).trim();
		if (/duplicate|already/i.test(text)) {
			return 'exists';
		}
		throw new Error(`Save failed: ${text}`);
	}
	return 'created';
}

async function deleteExisting(page, {viewCommand, navigation, idParam, deleteAction}) {
	await page.goto(manageURL(viewCommand, {navigation}));
	await page.waitForLoadState('networkidle');

	const ids = await page.evaluate((idParam) => {
		const pattern = new RegExp(`${idParam}=(\\d+)`);
		const found = new Set();
		for (const anchor of document.querySelectorAll('a[href]')) {
			const match = anchor.href.match(pattern);
			if (match) found.add(match[1]);
		}
		return [...found];
	}, idParam);

	if (!ids.length) {
		return 0;
	}

	const authToken = await page.evaluate(() => Liferay.authToken);
	for (const id of ids) {
		const url = new URL(`${BASE}/group/control_panel/manage`);
		url.searchParams.set('p_p_id', PORTLET);
		url.searchParams.set('p_p_lifecycle', '1');
		url.searchParams.set('p_p_state', 'maximized');
		url.searchParams.set('p_p_mode', 'view');
		url.searchParams.set(`${NS}jakarta.portlet.action`, deleteAction);
		url.searchParams.set(`${NS}${idParam}`, id);
		url.searchParams.set('p_auth', authToken);
		await page.goto(url.toString());
		await page.waitForLoadState('networkidle');
	}
	return ids.length;
}

const browser = await chromium.launch({headless: HEADLESS});
const context = await browser.newContext({ignoreHTTPSErrors: true});
const page = await context.newPage();

try {
	console.log(`Signing in as ${USER} ...`);
	await page.goto(`${BASE}/c/portal/login`);
	await page.getByLabel('Email Address').fill(USER);
	await page.getByLabel('Password', {exact: true}).fill(PASSWORD);
	await page.getByLabel('Sign In').getByRole('button', {name: 'Sign In'}).click();
	await page.waitForLoadState('networkidle');

	const asRemoved = await deleteExisting(page, {
		viewCommand: '/oauth_client_admin/view_oauth_client_as_local_metadata',
		navigation: 'oauth-client-as-local-metadata',
		idParam: 'oAuthClientASLocalMetadataId',
		deleteAction: '/oauth_client_admin/delete_oauth_client_as_local_metadata',
	});
	if (asRemoved) {
		console.log(`Removed ${asRemoved} existing Authorization Server entr${asRemoved > 1 ? 'ies' : 'y'}.`);
	}

	console.log('RFC-8414: Authorization Server Local Metadata ...');
	await page.goto(manageURL('/oauth_client_admin/update_oauth_client_as_local_metadata'));
	await set(page, 'issuer', ISSUER);
	await set(page, 'supportedScopes', SCOPES);
	await set(page, 'authorizationEndpoint', `${BASE}/o/oauth2/authorize`);
	await set(page, 'jwksURI', `${BASE}/o/oauth2/jwks`);
	await set(page, 'tokenEndpoint', `${BASE}/o/oauth2/token`);
	await set(page, 'registrationEndpoint', `${BASE}/o/oauth2/register`);
	await check(page, 'localWellKnownEnabled');
	console.log(`  ${await save(page)} -> ${ISSUER}/.well-known/oauth-authorization-server`);

	const prRemoved = await deleteExisting(page, {
		viewCommand: '/oauth_client_admin/view_oauth_client_pr_local_metadata',
		navigation: 'oauth-client-pr-local-metadata',
		idParam: 'oAuthClientPRLocalMetadataId',
		deleteAction: '/oauth_client_admin/delete_oauth_client_pr_local_metadata',
	});
	if (prRemoved) {
		console.log(`Removed ${prRemoved} existing Protected Resource entr${prRemoved > 1 ? 'ies' : 'y'}.`);
	}

	console.log('RFC-9728: Protected Resource Local Metadata ...');
	await page.goto(manageURL('/oauth_client_admin/update_oauth_client_pr_local_metadata'));
	await set(page, 'protectedResourceURI', `${BASE}/o/mcp`);
	await set(page, 'authorizationServers', ISSUER);
	await set(page, 'scopesSupported', SCOPES);
	await check(page, 'localWellKnownEnabled');
	console.log(`  ${await save(page)} -> ${BASE}/.well-known/oauth-protected-resource/o/mcp`);

	console.log('Done.');
} catch (error) {
	console.error(error);
	process.exitCode = 1;
} finally {
	await browser.close();
}
