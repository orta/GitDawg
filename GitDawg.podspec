require 'json'

pkg_version = lambda do |dir_from_root = '', version = 'version'|
  path = File.join(__dir__, dir_from_root, 'package.json')
  JSON.parse(File.read(path))[version]
end

gitdawg_version = pkg_version.call
react_native_version = pkg_version.call('node_modules/react-native')

Pod::Spec.new do |s|
  s.name             = 'GitDawg'
  s.version          = gitdawg_version
  s.summary          = 'Components for GitHawk.'
  s.homepage         = 'https://github.com/orta/GitDawg'
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { 'orta' => 'orta.therox@gmail.com' }
  s.source           = { git: 'https://github.com/orta/GitDawg.git', tag: s.version.to_s }

  s.platform       = :ios, '9.0'

  s.source_files   = 'Pod/Classes/**/*.{h,m}'
  s.resources      = 'Pod/Assets/{GitDawg.js,assets}'

  # React
  s.dependency 'React/Core', react_native_version
  s.dependency 'React/CxxBridge', react_native_version
  s.dependency 'React/RCTAnimation', react_native_version
  s.dependency 'React/RCTCameraRoll', react_native_version
  s.dependency 'React/RCTImage', react_native_version
  s.dependency 'React/RCTLinkingIOS', react_native_version
  s.dependency 'React/RCTNetwork', react_native_version
  s.dependency 'React/RCTText', react_native_version

  # React's dependencies
  s.dependency 'yoga', "#{react_native_version}.React"

  podspecs = [
    'node_modules/react-native/third-party-podspecs/DoubleConversion.podspec',
    'node_modules/react-native/third-party-podspecs/Folly.podspec',
    'node_modules/react-native/third-party-podspecs/glog.podspec'
  ]
  podspecs.each do |podspec_path|
    podspec_json = JSON.parse(`pod ipc spec #{podspec_path}`)
    s.dependency podspec_json['name'], podspec_json['version']
  end
end
