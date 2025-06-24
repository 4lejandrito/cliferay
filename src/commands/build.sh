cd $(cliferay folder)
cliferay ant setup-profile-dxp
cliferay ant all
(cd modules/util/portal-tools-rest-builder-test-api && cliferay deploy)
(cd modules/util/portal-tools-rest-builder-test-client && cliferay deploy)
(cd modules/util/portal-tools-rest-builder-test-impl && cliferay deploy)
(cd modules/test/playwright && npm install)
