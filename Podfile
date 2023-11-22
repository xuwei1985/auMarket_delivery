platform :ios, '11.0'
source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'
target "auMarket" do

pod 'AFNetworking'
pod 'MJRefresh', '~> 3.1.0'
pod 'SVProgressHUD', '~> 2.0.3'
pod 'SDWebImage', '~> 3.7.6'
pod 'JPush', '~> 2.1.6'
pod 'Masonry', '~> 1.0.0'
pod 'UICKeyChainStore', '~> 2.1.0'
pod 'TMCache', '~> 2.1.0'
pod 'GoogleMaps', '5.1.0'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
        end
    end
end


