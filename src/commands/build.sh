cd $(cliferay home)
cliferay ant all
for module in external*-api external*-impl api client impl; do
    for dir in modules/util/portal-tools-rest-builder-test-$module; do
        # Renamed modules leave behind folders holding only ignored files
        [[ -f $dir/build.gradle ]] || continue
        (cd $dir && cliferay deploy)
    done
done
