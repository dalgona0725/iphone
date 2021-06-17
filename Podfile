# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

def network_pods
  pod 'ReachabilitySwift', '3'
end

def graphics_pods
pod 'SlackTextViewController’
pod 'LoremIpsum'
pod 'DropDown',     '2.3.13'
end

def broadcast_pods
#RTMP Streaming
pod 'HaishinKit', '~> 1.0.7'
end

def thirdParty_pods
# Google & Naver & Kakao login
pod 'GoogleSignIn'
pod 'naveridlogin-sdk-ios'
pod 'KakaoSDKCommon'  # 필수 요소를 담은 공통 모듈
pod 'KakaoSDKAuth'  # 사용자 인증
pod 'KakaoSDKUser'  # 카카오 로그인, 사용자 관리
end

target 'PopkonAir' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  network_pods
  
  graphics_pods
    
  broadcast_pods
  
  thirdParty_pods
  
end
    
