import java.util.Properties

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val signingProperties = Properties().apply {
    val propertiesFile = rootProject.file("key.properties")
    if (propertiesFile.isFile) propertiesFile.inputStream().use(::load)
}

fun signingValue(environment: String, property: String): String? =
    (System.getenv(environment) ?: signingProperties.getProperty(property))
        ?.takeIf { it.isNotBlank() }

val productionId = providers.gradleProperty("plannerApplicationId").orNull
    ?: System.getenv("TASK_PLANNER_APPLICATION_ID")
val uploadStore = signingValue("TASK_PLANNER_UPLOAD_STORE", "storeFile")?.let(rootProject::file)
val uploadStorePassword = signingValue("TASK_PLANNER_UPLOAD_STORE_PASSWORD", "storePassword")
val uploadAlias = signingValue("TASK_PLANNER_UPLOAD_ALIAS", "keyAlias")
val uploadKeyPassword = signingValue("TASK_PLANNER_UPLOAD_KEY_PASSWORD", "keyPassword")
val signingReady = uploadStore?.isFile == true &&
    uploadStore.name != "debug.keystore" && uploadAlias != "androiddebugkey" &&
    uploadStorePassword != null && uploadAlias != null && uploadKeyPassword != null

// Merging and auditing the release manifest can run without credentials.
gradle.taskGraph.whenReady {
    val packagesRelease = allTasks.any { task ->
        task.project == project &&
            Regex("^(assemble|bundle|package|sign|publish|install|validateSigning).*Release").containsMatchIn(task.name)
    }
    if (packagesRelease) {
        if (productionId == null ||
            !Regex("^[a-zA-Z][a-zA-Z0-9_]*(\\.[a-zA-Z][a-zA-Z0-9_]*)+$").matches(productionId) ||
            productionId.startsWith("com.example.")) {
            throw GradleException("Release requires the owner-approved Android application ID. Set TASK_PLANNER_APPLICATION_ID or plannerApplicationId.")
        }
        if (!signingReady) {
            throw GradleException("Release requires a valid upload keystore and its credentials. See docs/android-release.md.")
        }
    }
}

android {
    namespace = "com.example.task_planner"
    compileSdk = maxOf(flutter.compileSdkVersion, 37)
    ndkVersion = flutter.ndkVersion

    compileOptions {
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        applicationId = productionId ?: "com.example.task_planner"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = maxOf(flutter.targetSdkVersion, 36)
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        if (signingReady) {
            create("upload") {
                storeFile = uploadStore
                storePassword = uploadStorePassword
                keyAlias = uploadAlias
                keyPassword = uploadKeyPassword
            }
        }
    }

    buildTypes {
        release {
            if (signingReady) signingConfig = signingConfigs.getByName("upload")
            isMinifyEnabled = true
            isShrinkResources = true
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")
}
