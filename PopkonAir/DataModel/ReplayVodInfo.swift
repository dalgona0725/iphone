//
//  ReplayVodInfo.swift
//  PopkonAir
//
//  Created by BumSoo Park on 2021/05/10.
//  Copyright © 2021 The E&M. All rights reserved.
//

import UIKit

struct ReplayVodInfo: Codable {
    /// [PK] VOD 코드
    var vodCode = ""
    /// VOD 등록일자코드 (YYYYmmDDhhNNss)
    var vRegDate  = ""
    /// VOD 누적시청수
    var vViewCnt  = ""
    /// [IX]방송자 회원아이디
    var vSignId = ""
    /// 방송제목
    var vCastTitle = ""
    /// [IX]방송자 파트너사 코드 ( ASP )
    var vPartnerCode = ""
    /// 방송자회원닉네임
    var vNickName = ""
    /// 방송자 프로필이미지 파일경로
    var vPfileName = ""
    /// 방송자 레벨
    var brdcrLvl = ""
    /// 카테고리 코드(참조)
    ///    2    영화
    ///    3    음악
    ///    4    스포츠
    ///    5    게임
    ///    7    개인
    ///    8    19+
    ///    30    커머스
    var vCategory = ""
}
