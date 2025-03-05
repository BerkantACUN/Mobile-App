import java.util.Properties

// key.properties dosyasını yükleme
val keystorePropertiesFile = rootProject.file("android/key.properties")
val keystoreProperties = Properties().apply {
    load(keystorePropertiesFile.inputStream())
}

// extra üzerinden kotlin sürümünü tanımla
extra["kotlin_version"] = "1.8.22"

android {
    namespace = "com.example.cy_app_"
    
    compileSdk = rootProject.extra["compileSdkVersion"] as Int
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    defaultConfig {
        applicationId = "com.example.cy_app_"
        minSdk = rootProject.extra["minSdkVersion"] as Int
        targetSdk = rootProject.extra["targetSdkVersion"] as Int
        versionCode = 1
        versionName = "1.0.0"
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["storeFile"] as String)
            storePassword = keystoreProperties["storePassword"] as String
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
        }
    }

    buildTypes {
        getByName("release") {
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    implementation("androidx.multidex:multidex:2.0.1")
    implementation("org.jetbrains.kotlin:kotlin-stdlib:${extra["kotlin_version"]}")
}
