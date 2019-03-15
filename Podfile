source 'https://github.com/CocoaPods/Specs.git'

platform :ios, ‘10.0’
inhibit_all_warnings!
post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['ARCHS'] = 'armv7 armv7s arm64'
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.0'
        end
    end
end

def shared_pods
    pod 'YYKit'
    pod 'Masonry'
    pod 'MJRefresh'
    pod 'AFNetworking'
    pod 'IDMPhotoBrowser'
    pod 'UITableView+FDTemplateLayoutCell'   
end

target ‘wurongbiao photos’ do
    shared_pods
end



