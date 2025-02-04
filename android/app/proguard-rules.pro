-keep class kotlin.** { *; }
-keep class kotlinx.** { *; }
-keepattributes *Annotation*
-dontwarn kotlinx.**
# Keep BouncyCastle classes
-keep class org.bouncycastle.** { *; }
-keepnames class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**