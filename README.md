# releaseprocess
demo release process to figure out how to manage versions for each module of a single repo - multi module project. 

To do a **full** release:
```
cd ${basedir}/releaseparent
mvn -Drevision=2.00.001 -Drelease.versionRange=[2.0,2.00.001] clean deploy

# then to figure out the versions of all modules after the release

cd ${basedir}/releaseparent/target
mvn -f flattened-pom.xml versions:use-latest-releases
```

To release **specific modules** and *there dependents*: 
```
cd ${basedir}/releaseparent
mvn -Drevision=2.00.002 -Drelease.versionRange=[2.0,2.00.002] --projects ../appone,../apptwo,../releasebom,../releaseparent --also-make-dependents clean deploy

# then to figure out the versions of all modules after the release

cd ${basedir}/releaseparent/target
mvn -f flattened-pom.xml versions:use-latest-releases
```

---

Jenkins pipeline is work in progress and soon the jenkinsfile for creating the pipeline will be added

---

The release process (chronological sequence of steps) are as follows. However creating a visual representation of it is WIP. 

**Software Developer:**

1. Creates a feature branch
2. Using the pipeline builder - developer will setup the CI/CD pipeline for the feature branch. All artifacts generated will have the version as <Feature Number>-SNAPSHOT

**Team City:**

3. For the Feature Branch - the CI/CD will do a full build - every time the code is committed
4. Sequence would be - build -> unit test -> Sonar -> Nexus Deploy -> Deploy to Dev/Test

**Release Manager (or a DevOps Engineer):**

5. Creates a release branch
6. Using the pipeline builder - creates a CI/CD pipeline for the release branch. All artifacts generated will have the version number as <major-version>.<minor-version>.<buildNumber> 
7. Setup additional properties in Team City/Maven Profiles for the release build
8. Every module can have different version number

**Developer:**

9. Merge the code of the feature branch into the release branch

**Release Manager:**

10. Trigger the pipeline

**Team City:**

11. Execute the pipeline
12. Build the releaseparent (parent & aggregator project) - which will trigger the maven reactor to identify dependents and build order. Modules getting built will have the same version as that of the releaseparent. For each module to be built:

   * Perform build
   * Perform unit tests
   * Perform Sonar Analysis
   * deploy artifact to maven repo

12. This will trigger build of ```releasemodule``` which will create an assembly of all the modules that have been built (creates a tar.gz). It will be deployed to nexus
13. Then build the ```releasebom``` and ```releaseparent```. They will have the same version as the releaseparent
   
To be continued...
