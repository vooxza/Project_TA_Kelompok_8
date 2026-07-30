allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    project.evaluationDependsOn(":app")
}

// Fix untuk plugin lama (mis. blue_thermal_printer) yang belum punya
// namespace di build.gradle-nya, wajib untuk AGP versi baru.
subprojects {
    fun applyNamespaceFix() {
        val androidExt = extensions.findByName("android")
        if (androidExt is com.android.build.gradle.BaseExtension) {
            if (androidExt.namespace == null) {
                val manifestFile = file("src/main/AndroidManifest.xml")
                if (manifestFile.exists()) {
                    val parsedManifest = groovy.xml.XmlSlurper().parse(manifestFile)
                    val packageName = parsedManifest.getProperty("@package").toString()
                    if (packageName.isNotEmpty()) {
                        androidExt.namespace = packageName
                    }
                }
            }
        }
    }

    if (project.state.executed) {
        applyNamespaceFix()
    } else {
        afterEvaluate {
            applyNamespaceFix()
        }
    }
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}