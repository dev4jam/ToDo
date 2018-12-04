# Uncomment the next line to define a global platform for your project
platform :ios, '11.2'

target 'ToDo' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  # Pods for ToDo
  use_frameworks!

  # Pods for ToDo
  pod 'RIBs'
  pod 'SnapKit'
  pod 'RxCocoa'
  pod 'IGListKit'
  pod 'TransitionButton'#, :git => "https://github.com/AladinWay/TransitionButton.git"
  pod 'SVProgressHUD'
  pod 'DynamicButton'
  pod 'Realm'
  pod 'RealmSwift'
  pod 'REFrostedViewController'
  pod 'Eureka'

  target 'ToDoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'ToDoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '4.2'
    end
  end
end
