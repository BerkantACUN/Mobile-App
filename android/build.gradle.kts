// android/build.gradle.kts
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        // Android Gradle Plugin
        classpath("com.android.tools.build:gradle:8.1.0")
        // Google Services Plugin (Firebase, vs.)
        classpath("com.google.gms:google-services:4.3.15")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Ortak ayarlar: compileSdk, minSdk ve targetSdk değerleri
extra["compileSdkVersion"] = 34
extra["minSdkVersion"] = 23
extra["targetSdkVersion"] = 34
