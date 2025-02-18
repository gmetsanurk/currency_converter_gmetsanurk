# Uncomment the next line to define a global platform for your project
platform :ios, '14.0'

def common_pods
  pod 'Masonry'
  pod 'SnapKit', '~> 5.7.1'
  pod 'Moya', '~> 15.0'
  pod 'Moya/Combine', '~> 15.0'
  pod 'NetworkManager', :path => 'NetworkManager'
end

target 'CurexConverter' do
  common_pods
end

target 'CurexConverter-ObjC' do
  common_pods
end

target 'CurexConverter-tvOS' do
  platform :tvos, '14.0'
  common_pods
end

target 'CurexConverterTests' do
  common_pods
end

target 'CurexConverterUITests' do
  common_pods
end
