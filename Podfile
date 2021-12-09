# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Aurora' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Aurora
  pod 'lottie-ios', '~> 3.1.5'
  pod 'TTTAttributedLabel', '~> 2.0.0'
  pod 'Swinject'
  pod 'SwinjectAutoregistration'
  pod 'RSKGrowingTextView'
  pod 'RealmSwift'
  pod 'RxSwift'
  pod 'CocoaLumberjack/Swift'

  pod 'CocoaMQTT', '1.3.0-rc.1'
  pod 'CocoaMQTT/WebSockets', '1.3.0-rc.1'
  
  pre_install do |installer|
    def installer.verify_no_static_framework_transitive_dependencies; end
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '4.2'
      config.build_settings['ENABLE_TESTABILITY'] = 'YES'
      config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = 'arm64'
      if Gem::Version.new('13.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end
  end
end

end
