import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")

if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(keystorePropertiesFile.inputStream())
}

android {
    namespace = "com.rabik.cricketscorer"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.rabik.cricketscorer"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName

        val admobAppId =
            (project.findProperty("admobAppId") as String?) ?: "ca-app-pub-3940256099942544~3347511713"
        manifestPlaceholders["ADMOB_APP_ID"] = admobAppId
    }

    signingConfigs {
        create("release") {
            val storeFilePathRaw = keystoreProperties.getProperty("storeFile")
            val storePasswordValue = keystoreProperties.getProperty("storePassword")
            val keyAliasValue = keystoreProperties.getProperty("keyAlias")
            val keyPasswordValue = keystoreProperties.getProperty("keyPassword")

            if (
                !keystorePropertiesFile.exists() ||
                storeFilePathRaw.isNullOrBlank() ||
                storePasswordValue.isNullOrBlank() ||
                keyAliasValue.isNullOrBlank() ||
                keyPasswordValue.isNullOrBlank()
            ) {
                throw GradleException(
                    "Release signing is not configured. Add android/key.properties with storeFile, storePassword, keyAlias, and keyPassword.",
                )
            }

            val storeFilePath: String = storeFilePathRaw
            val releaseKeystoreFile = keystorePropertiesFile.parentFile.resolve(storeFilePath)
            if (!releaseKeystoreFile.exists()) {
                throw GradleException(
                    "Release keystore not found at: ${releaseKeystoreFile.absolutePath}",
                )
            }

            storeFile = releaseKeystoreFile
            storePassword = storePasswordValue
            keyAlias = keyAliasValue
            keyPassword = keyPasswordValue
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}