//
//  AppShareEnum.swift
//  PopkonAir
//
//  Created by Eugene Jeong on 2017. 7. 16..
//  Copyright © 2017년 roy. All rights reserved.
//


//MARK: - Enum
/// 카테고리방송 정렬방식.
enum CastSortBy : String {
    ///최신순
    case latest         =  "0"
    ///인기순
    case hotest         =  "1"
    ///시청순
    case viewCount      =  "2"
	
	static let allValues = [ hotest, latest , viewCount ]
    
    func stringValue()->String {
        switch self {
        case .latest:
            return I18N.live_sortLatest.localized
        case .hotest:
            return I18N.live_sortHotest.localized
        case .viewCount:
            return I18N.live_sortView.localized
        }
    }
}

/// 개인방송 정렬방식.
enum MCSortBy : String {
    ///최신순
    case latest         =  "0"
    ///시청순
    case viewCount      =  "1"
    ///추천순
    case suggestCount   =  "2"
    
    func stringValue()->String {
        switch self {
        case .latest:
            return I18N.text_sortLatest.localized
        case .suggestCount:
            return I18N.text_sortRecommend.localized
        case .viewCount:
            return I18N.text_sortViewer.localized
        }
    }
}

/// Celuv Live 요청방식
enum CeluvLiveCommand : String {
    /// 전체 목록
    case all = "0"
    /// 검색
    case search = "1"
}

/// Celuv 방송자 타입
enum CeluvLiveCaster : String {
    /// 전체 방송자
    case all = "0"
    /// 셀럽 방송자
    case celuv = "1"
    /// 일반 방송자
    case user = "2"
}

/// Celuv VOD요청방식
enum CeluvVODType : String {
    /// vod 목록
    case vod = "0"
    /// celuv VOD 목록
    case celuvVod = "1"
    /// vod 검색 목록
    case searchVod = "2"
}

enum CeluvVodCategoryType : String {
    /// 전체
    case all = "0"
    /// 나머지VOD
    case etcVod = "1"
    /// I’m Celuv
    case celuvVod = "2"
	/// :Celuv news
	case news = "3"
}

/// VOD목록 정렬방식.
enum VODSortBy : String {
    ///최신순
    case latest         =  "0"
    ///조회순
    case viewCount      =  "1"
	///추천순
	case suggest      =  "2"
}

/// VOD코멘트 정렬장식.
enum VODCommentSortBy : String {
    ///최신순
    case latest         = "0"
    ///인기순
    case hotest         = "1"
}

/// 순위형태.
enum RankCode : String {
    ///추천 순위
    case suggest        =  "0"
    ///즐겨찾기 순위
    case favorite       =  "1"
    ///시청 순위
    case viewCount      =  "2"
    ///종합 순위
    case sum            =  "3"
    
    func stringValue() -> String {
        switch self {
        case .sum:
            return I18N.text_sortTotal.localized
        case .suggest:
            return I18N.text_sortRecommend.localized
        case .favorite:
            return I18N.text_sortFavorite.localized
        case .viewCount:
            return I18N.text_sortView.localized
        }
    }
}

/// 즐겨찾기 정보 형태.
enum DataType : String {
    ///최신순
    case add         =  "0"
    ///시청순
    case remove      =  "1"
}

/// 동영상 명령스타일
enum CommandType: String {
    ///시작
    case start      =  "0"
    ///종료
    case end        =  "1"
}

/// 방송명령 스타일
enum BCCommandType: String {
    ///시작
    case start      =  "0"
    ///방송일시정지
    case pause      =  "1"
    ///종료
    case end        =  "2"
}

enum BCEndType : String {
    ///해당없음
    case none           =  "0"
    ///방송일시정지
    case pause          =  "1"
    /// 정상 종료
    case end            =  "2"
    /// 비정상 종료
    case endWithError   =  "3"
    /// 관리자 강제 종료
    case endByAdmin     =  "4"
    /// 중복로그인 강제 종료
    /// 삭제 처리
//    case endByDuplicate =  "5"
}

enum CoinUseType : Int {
    /// 방송중 코인 선물
    case giftCoin       = 0
    /// 유료방송 입장 코인사용
    case paidCoin       = 2
}

/// 푸쉬 알림 커맨드
enum PushCommandType: String {
    /// 정보설정
    case setup      = "0"
    /// 정보검색
    case search     = "1"
    /// pushKey 재설정
    case reset      = "2"
}

/// 메세지리스트 타입
enum LetterListType : Int {
    /// 받은목록
    case received   = 0
    /// 보낸목록
    case sent       = 1
}

/// 메세지 타입
enum LetterReadType : Int {
    /// 받은목록
    case received   = 2
    /// 보낸목록
    case sent       = 3
}


///MARK - View Category
enum GiftUseType : String {
    /// [선물] 방송중 방송자 선물
    case giftCast           = "0"
    
    /// [선물] 웹사이트 방송자 선물
    case giftWebsite        = "1"
    
    /// [방송시청] 프리미엄 방송시청 입장 코인금액
    case entrancePremium    = "2"
    
    /// [방송시청] 프리미엄 방송시청 종량 코인금액
    case rateCostPremium    = "3"
    
    /// [아이템] 구매
    case buyitem            = "4"
    
    /// [방송시청-후불제] 프리미엄 방송 입장료
    case defferedEntrancePremium = "5"
    
    /// [방송시청-후불제] 프리미엄 방송 시청료
    case defferedrateCostPremium = "6"
    
    /// [선물-후불제] 방송중 방송자 선물
    case defferedGiftCast   = "7"
    
    /// 기부
    case donation           = "8"
    
    /// 코인소진 취소
    case cancelUsed         = "9"
    
    /// [선물] 쇼핑상품선물
    case giftShopping       = "10"
    
    /// 전광판 사용
    case useBoard           = "11"
    
    /// [선물] 방송자 다시보기 팬클럽 가입
    case joinFanclub        = "12"
    
    /// [선물] 방송자 다시보기 시청중 선물
    case watchVod           = "23"
}


enum SearchViewCategoryType : Int {
    case liveList        = 0
    case vodList         = 1
    
    func stringValue()-> String {
        switch self {
        case .liveList:
            return I18N.text_liveCast.localized
        case .vodList:
            return I18N.text_vodContents.localized
        }
    }
}

enum MCVodViewCategoryType : Int {
    case vodList         = 0
    case fanList         = 1
    
    func stringValue()-> String {
        switch self {
        case .vodList:
            return I18N.text_vodContents.localized
        case .fanList:
            return I18N.text_bigfanList.localized
        }
    }
}

/// 랭킹 종류값
enum RankViewTab : String, CustomStringConvertible {
    /// 실시간랭킹
    case live   = "0"
    /// 전체랭킹
    case total  = "1"
    /// 신인랭킹
    case rookie = "2"
    /// 주말랭킹
    case weekend = "3"
    
    static let allValues = [ total, rookie, live, weekend ]
    
    public var description: String {
        switch self {
        case .total:
            return I18N.text_totalRanking.localized
        case .rookie:
            return I18N.text_rookieRanking.localized
        case .live:
            return I18N.text_liveRanking.localized
        case .weekend:
            return I18N.text_weekendRanking.localized
        }
    }
}

/// 랭킹 정렬값
enum RankSortType : String, CustomStringConvertible {
    /// 주간
    case week   = "1"
    /// 월간
    case month  = "2"
    public var description: String {
        switch self {
        case .week:
            return I18N.text_weekRanking.localized
        case .month:
            return I18N.text_monthRanking.localized
        }
    }
}

/// 선물하기 탭관련 종류값들
enum GiftMenuTab : Int {
    /// 코인 선물
    case coin
    /// 이벤트 코인 선물
    case event
    /// 럭셔리 선물
    case luxury
    /// 두산 선물 
    case ascending
    /// 연속 코인 선물
    case series
    
    static let allValues = [ coin, event, luxury, ascending, series ]
}

// 보통 팝콘
enum NormalPopkonType : Int {
    case none       = 0
    case small      = 10
    case medium     = 50
    case large      = 100
    
    static let allValues = [ small, medium, large ]
    
    func stringValue()->String {
        switch self {
        case .none:
            return I18N.text_unknown.localized
        case .small:
            return "10" + I18N.ui_numOfCoin.localized
        case .medium:
            return "50" + I18N.ui_numOfCoin.localized
        case .large:
            return "100" + I18N.ui_numOfCoin.localized
        }
    }
    
    func keycode() -> Int {
        return 0
    }
    
    func getImage() -> UIImage? {
        return #imageLiteral(resourceName: "ic_popkon_n")
    }
}

/// 이벤트 팝콘 종류
enum EventPopkonType : Int {
    case none       = 0
    /// 카라멜팝콘
    case caramel      =  17
    /// 스위트팝콘
    case sweet        =  16
    /// 어니언팝콘
    case onion        =  15
    
    func stringValue()->String {
        switch self {
        case .none:
            return I18N.text_unknown.localized
        case .caramel:
            return I18N.text_caramel.localized + coinName
        case .sweet:
            return I18N.text_sweet.localized + coinName
        case .onion:
            return I18N.text_onion.localized + coinName
        }
    }
    
    func getUserCoin() -> Int {
        switch self {
        case .none:
            return 0
        case .caramel:
            return userInfo.cCoin
        case .sweet:
            return userInfo.sCoin
        case .onion :
            return userInfo.aCoin
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .none:
            return nil
        case .caramel:
            return #imageLiteral(resourceName: "popkon_caramel")
        case .sweet:
            return #imageLiteral(resourceName: "popkon_sweet")
        case .onion :
            return #imageLiteral(resourceName: "popkon_onion")
        }
    }
    
    func isValid() -> Bool {
        return self != .none
    }
    
    static let allValues = [ caramel, sweet, onion ]
}

/// 럭셔리 팝콘 종류
enum LuxuryPopkonType : Int {
    case none       = 0
    case goldrose   = 50
    case perfume    = 51
    case shoes      = 52
    case bag        = 53
    case goldbar    = 54
    case ring       = 55
    case car        = 56
    case yacht      = 57
    case house      = 58
    
    func stringValue()->String {
        switch self {
        case .none:
            return I18N.text_unknown.localized
        case .goldrose:
            return I18N.text_goldRose.localized
        case .perfume:
            return I18N.text_perfume.localized
        case .shoes:
            return I18N.text_shoes.localized
        case .bag:
            return I18N.text_handbag.localized
        case .goldbar:
            return I18N.text_goldBar.localized
        case .ring:
            return I18N.text_daimondRing.localized
        case .car:
            return I18N.text_sportCar.localized
        case .yacht:
            return I18N.text_yacht.localized
        case .house:
            return I18N.text_penthouse.localized
        }
    }
    
    func getImage() -> UIImage? {
        switch self {
        case .none:
            return nil
        case .goldrose:
            return #imageLiteral(resourceName: "item_goldrose")
        case .perfume:
            return #imageLiteral(resourceName: "item_perfume")
        case .shoes:
            return #imageLiteral(resourceName: "item_shoes")
        case .bag:
            return #imageLiteral(resourceName: "item_bag")
        case .goldbar:
            return #imageLiteral(resourceName: "item_goldbar")
        case .ring:
            return #imageLiteral(resourceName: "item_diamondring")
        case .car:
            return #imageLiteral(resourceName: "item_sportscar")
        case .yacht:
            return #imageLiteral(resourceName: "item_yacht")
        case .house:
            return #imageLiteral(resourceName: "item_penthouse")
        }
    }
    
    func getUserCoin() -> Int {
        switch self {
        case .none:
            return 0
        case .goldrose:
            return userInfo.L1Coin
        case .perfume:
            return userInfo.L2Coin
        case .shoes:
            return userInfo.L3Coin
        case .bag:
            return userInfo.L4Coin
        case .goldbar:
            return userInfo.L5Coin
        case .ring:
            return userInfo.L6Coin
        case .car:
            return userInfo.L7Coin
        case .yacht:
            return userInfo.L8Coin
        case .house:
            return userInfo.L9Coin
        }
    }
    
    func isValid() -> Bool {
        return self != .none
    }
    
    static let allValues = [ goldrose, perfume, shoes, bag, goldbar, ring, car, yacht, house ]
}

enum FreezeStatus : String {
    case freeze     = "0"
    case unfreeze   = "1"
    func stringValue() -> String {
        switch self {
        case .freeze:
            return I18N.text_freeze.localized
        case .unfreeze:
            return I18N.text_unfreeze.localized
        }
    }
}

// 방송하기 채팅창 얼리기 등급
enum FreezeLevel : Int, CustomStringConvertible {
    
    case all        = 0
    case manager    = 1
    case vip        = 2
    case daimond    = 3
    case gold       = 4
    case silver     = 5
    
    static let allValues = [ all, manager, vip, daimond, gold, silver ]
    
    func stringValue() -> String {
        switch self {
        case .all:
            return I18N.text_total.localized
        case .manager:
            return I18N.text_manager.localized + " " + I18N.text_under.localized
        case .vip:
            return userInfo.fanVipGroupName + " " + I18N.text_under.localized
        case .daimond:
            return userInfo.fanDiaGroupName + " " + I18N.text_under.localized
        case .gold:
            return userInfo.fanGoldGroupName + " " + I18N.text_under.localized
        case .silver:
            return userInfo.fanSilverGroupName + " " + I18N.text_under.localized
        }
    }
    
    public var description: String {
        switch self {
        case .all:
            return I18N.text_total.localized
        case .manager:
            return I18N.text_manager.localized + " " + I18N.text_under.localized
        case .vip:
            return userInfo.fanVipGroupName + " " + I18N.text_under.localized
        case .daimond:
            return userInfo.fanDiaGroupName + " " + I18N.text_under.localized
        case .gold:
            return userInfo.fanGoldGroupName + " " + I18N.text_under.localized
        case .silver:
            return userInfo.fanSilverGroupName + " " + I18N.text_under.localized
        }
    }
    
    func codeValue() -> String {
        switch self {
        case .all:
            return "9"
        case .manager:
            return "8"
        case .vip:
            return "0"
        case .daimond:
            return "1"
        case .gold:
            return "2"
        case .silver:
            return "3"
        }
    }
}

enum BCListNum : Int {
    ///방송목록 일반 정렬
    case normal = 1
    ///방송목록 실버 정렬 (실버 리스트업 아이템)
    case silver = 2
    ///방송목록 골드 정렬 (골드 리스트업 아이템)
    case gold   = 3
    
    func stringValue()->String {
        switch self {
        case .normal:
            return I18N.ui_noListup.localized
        case .silver:
            return I18N.ui_silverListup.localized
        case .gold:
            return I18N.ui_goldListup.localized
        }
    }
}

enum BCTarget : Int {
    case all    = 0
    case celuv  = 10
    
    static let allValues = [ all, celuv ]
    
    func stringValue()->String {
        switch self {
        case .all:
            return "전체송출"
        case .celuv:
            return "셀럽티비만 송출"
        }
    }
}


enum BCQuality : Int {
    case low    = 0
    case normal = 1
    case high   = 2
    
    static let allValues = [ low, normal, high ]
    
    func stringValue()->String {
        switch self {
        case .low:
            return I18N.cast_lowQuality.localized
        case .normal:
            return I18N.cast_normalQuality.localized
        case .high:
            return I18N.cast_highQuality.localized
        }
    }
    
    func getBitrates() -> [Int] {
        switch self {
        case .low:
            return [ 500_000, 800_000,1500_000]
        case .normal:
            return [1000_000,1500_000,3000_000]
        case .high:
            return [1500_000,2500_000,4500_000]
        }
    }
    
    func getIndex() -> Int {
        switch self {
        case .low:
            return 0
        case .normal:
            return 1
        case .high:
            return 2
        }
    }
}

enum BCCastType: Int {
    case wowza       = 0
    case rtcVideo
    case rtcCall
    case rtcAudio
    case rtcOriginal
    
    
    static let allValues = [ wowza, rtcVideo] //, rtcCall] //, rtcAudio, rtcOriginal ]
    
    func stringValue()->String {
        switch self {
        case .wowza:
            return I18N.text_normal.localized
        case .rtcVideo:
            return I18N.text_premium.localized
        case .rtcAudio:
            return "음성"
        case .rtcOriginal:
            return "리모트"
        case .rtcCall:
            return "프리미엄일대일"
        }
    }
}

enum BCType : Int {
    case freeBroad01    = 0
    case OneOnOne       = 1
    case nothing        = 2
    case relay          = 3
    case vodBroad       = 4
    case fanclub        = 5
    case freeBroad02    = 6
    case payperview     = 7
}

enum BCOrientation : Int {
    case portrait
    case landscape
    
    func stringValue()->String {
        switch self {
        case .portrait:
            return "세로"
        case .landscape:
            return "가로"
        }
    }
}

/// 방송자 - 참여자 리스트 정렬 값
enum MemberListSort : Int {
    /// 팬등급순
    case fanGrade           = 0
    /// 팬레벨순
    case fanLevel           = 1
    /// 방송 입장순
    case entrance           = 2
    /// 방송 입장 최신순
    case entranceLatest     = 3
}

/// 유저 아이템 코드
enum UserItem : String {
    case megaPhone  = "AP"
    case pushItem   = "AR"
}

/// 시청자 선물관련 정보
struct WatcherInfo {
    var signID: String = ""
    // 유저가 방송자에게 선물준 이력 여부
    var isGift: Bool = false
    // 첫선물일 경우 참여자 목록상 민트색상 표시할지 여부
    var isFirstGift: Bool = false
    // 받은시간
    var receivedTime: TimeInterval = 0
    
    init(signID: String, isGift: Bool, isFirstGift: Bool) {
        self.signID = signID
        self.isGift = isGift
        self.isFirstGift = isFirstGift
        if isFirstGift {
            receivedTime = Date().timeIntervalSinceReferenceDate
        }
    }
}

// 코인선물 정보
struct GiftUserInfo {
    var coin: Int = 0
    var userID: String = ""
    var userPartnerID: String = ""
}


/// 방송인코딩관련 열거형
enum WZLowBandwidthScaling  {
    case best
    case low
    /// 기본값
    case normal
    case never
    
    func stringValue()->String {
        switch self {
        case .best:
            return "최적"
        case .low:
            return "낮음"
        case .normal:
            return "기본"
        case .never:
            return "최대"
        }
    }
    
    func getFloat() -> Float32 {
        switch self {
        case .best:
            return 0.0
        case .low:
            return 0.3
        case .normal:
            return 0.75
        case .never:
            return 1.0
        }
    }
}

enum WZLowBandwidthSkipCount {
    case one
    case two
    case three
    /// 기본값
    case four
    
    func getValue() -> UInt {
        switch self {
        case .one:
            return 1
        case .two:
            return 2
        case .three:
            return 3
        case .four:
            return 4
        }
    }
}

enum WZVideoKeyFrameInterval {
    case less
    /// 기본값
    case normal
    case more
    case maximum
    
    func getValue() -> UInt {
        switch self {
        case .less:
            return 15
        case .normal:
            return 30
        case .more:
            return 45
        case .maximum:
            return 60
        }
    }
}

enum WZVideoFrameBufferSizeMultiplier {
    case best
    case less
    /// 기본값
    case normal
    case more
    
    func getValue() -> UInt {
        switch self {
        case .best:
            return 0
        case .less:
            return 2
        case .normal:
            return 4
        case .more:
            return 10
        }
    }
}


/// 도우미 타입
enum PopkonHelper: Int {
//    case chat
    case alert
    case goal
    case subtitle
    
    func stringValue()->String {
        switch self {
//        case .chat:
//            return "chat"
        case .alert:
            return "alert"
        case .goal:
            return "goal"
        case .subtitle:
            return "subtitle"
        }
    }
    
    func getName()->String {
        switch self {
//        case .chat:
//            return I18N.ui_helper_menu_chat.localized
        case .alert:
            return I18N.ui_helper_menu_alert.localized
        case .goal:
            return I18N.ui_helper_menu_goal.localized
        case .subtitle:
            return I18N.ui_helper_menu_subtitle.localized
        }
    }
    
    func getDefalutSize() -> CGSize {
        return CGSize(width: 200, height: 200)
    }
    static let allValues = [ /*chat,*/ alert, goal, subtitle ]
}

enum CommerceEvent {
    case add
    case apply
    case info
    
    var code: String {
        switch self {
        case .add:
            return "commerceAdd"
        case .apply:
            return "adultSwitchOn"
        case .info:
            return "commerceOpenLink"
        }
    }
    static var eventHandler: String {
        return "mobile"
    }
}

/// REMOTE CONFIG 서버연결 속성.
enum QA_TEST_SERVER: String {
    /// 프로젝트 설정값에 따라 처리
    case none = "NO"
    /// 개발서버
    case development = "DEV"
    /// 스테이지 서버
    case stage = "STA"
}

/// 방송자 열혈팬 순위 리스트
/// 0:팬등급순(기본값), 1:팬레벨순
enum FanRankType: Int {
    case bigFan = 0
    case fanLevel = 1
}


/// 등급별 이미지
/// 권한 등급 (0:  일반 시청자, 1: 방송자 권한, 2: 매니저 권한, 3: 운영자 권한, 4: 관리자 권한)
enum GradeIconImage: Int {
    case mc_women, mc_man, manager, admin, super_admin, none
    
    func stringValue()->String {
        switch self {
        case .mc_women:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_mc_woman.png"
        case .mc_man:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_mc_man.png"
        case .manager:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_manager.png"
        case .admin:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_admin.png"
        case .super_admin:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_super.png"
        case .none:
            return ""
        }
    }
}

/// 등급별 이미지
/// 팬등급 (0: 최상위 팬등급 (VIP), 1: 상위 팬등급 (다이아), 2: 하위 팬등급 (골드), 3: 최하위 팬등급 (실버), 4: 팬등급 없음)
enum FanGradeIcon: Int {
    case vip, gold, silver, bronze, all

    func stringValue()->String {
        switch self {
        case .vip:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_fan_01.png"
        case .gold:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_fan_02.png"
        case .silver:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_fan_03.png"
        case .bronze:
            return "pic.popkontv.com/images/www/live/assets/chatlist/icon_fan_04.png"
        case .all:
            return ""
        }
    }
}

/// 커머스 영상 플로팅 뷰 위치
enum PIPPosition {
    case topLeft
    case bottomLeft
    case topRight
    case bottomRight
}

/// LiveShop 타입
enum LiveShopType: Int {
    case live, replay
    
    func getString() -> String {
        switch self {
        case .live:
            return I18N.ui_tabLive.localized
        case .replay:
            return I18N.ui_tabVod.localized
        }
    }
    
    static let count: Int = {
        var max: Int = 0
        while let _ = LiveShopType(rawValue: max) { max += 1 }
        return max
    }()
}
