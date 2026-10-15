Pod::Spec.new do |s|
  s.name             = 'flutter_jailbreak_guard'
  s.version          = '0.2.0'
  s.summary          = 'Jailbreak and root detection for Flutter.'
  s.description      = <<-DESC
Detects jailbroken iOS devices with IOSSecuritySuite and rooted Android devices with RootBeer.
                       DESC
  s.homepage         = 'https://github.com/TeddyYeung/flutter_jailbreak_guard'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'TeddyYeung' => 'teddyyeung515@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'flutter_jailbreak_guard/Sources/flutter_jailbreak_guard/**/*.swift'
  s.dependency 'Flutter'
  s.dependency 'IOSSecuritySuite', '~> 2.2'
  s.platform = :ios, '13.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
