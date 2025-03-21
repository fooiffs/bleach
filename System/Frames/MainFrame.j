scope MainFrame initializer Init
    globals
      private dialog NoSaveDialog = DialogCreate()
      
      private integer Frame_Main = 0
      private integer Frame_Sub = 0
      private integer currentCount = 0

      
      // integer array Frame_SelectBack
      // integer array Frame_SelectText

      // integer array Frame_ButtonsBackDrop       //아이템/스킬/메뉴 버튼 배경 아이콘
      
      integer array Frame_Info
      integer array Frame_InfoValue
      
      integer array Frame_MiniInfo
      integer array Frame_MiniInfoBackdrop
      integer array Frame_MiniInfoText
      integer array Frame_MiniInfoText2
      
      integer array Frame_Setting
      integer array Frame_SettingBackdrop
    endglobals

    function GetMainFrame takes nothing returns integer
      if ( Frame_Main == 0 ) then
        set Frame_Main = DzCreateFrameByTagName("SPRITE", "", DzGetGameUI(), "", 0)
        call DzFrameSetAbsolutePoint(Frame_Main, JN_FRAMEPOINT_TOPRIGHT, 0., 0.)
      endif
      return Frame_Main
    endfunction
    function GetSubFrame takes nothing returns integer
      if ( Frame_Sub == 0 ) then
        set Frame_Sub = DzCreateFrameByTagName("SPRITE", "", DzGetGameUI(), "", 0)
        call DzFrameSetAbsolutePoint(Frame_Sub, JN_FRAMEPOINT_TOPRIGHT, 0., 0.)
      endif
      return Frame_Sub
    endfunction
    function CountAdder takes nothing returns integer
      set currentCount = currentCount + 1
      return currentCount
    endfunction
    
    private function NoSaveNoTime takes nothing returns nothing
     local integer Relative = 0
      call DestroyTrigger(GetTriggeringTrigger())
      //일시 정지 버튼 비활성화 & 숨김
      call DzFrameSetEnable(DzFrameFindByName("PauseButton", 0), false)
      call DzFrameShow(DzFrameFindByName("PauseButton", 0), false)
      
      //게임 저장 버튼 비활성화
      call DzFrameSetEnable(DzFrameFindByName("SaveGameButton", 0), false)
      call DzFrameSetText(DzFrameFindByName("SaveGameButtonText", 0), "게임 저장 불가")
      
      call DzFrameSetEnable(DzFrameFindByName("LoadGameButton", 0), false)
      call DzFrameSetText(DzFrameFindByName("LoadGameButtonText", 0), "로드 또한 불가")
      
      call DzFrameSetEnable(DzFrameFindByName("SaveGameSaveButton", 0), false)
      call DzFrameShow(DzFrameFindByName("SaveGameSaveButton", 0), false)
      call DzFrameSetEnable(DzFrameFindByName("OverwriteOverwriteButton", 0), false)
      call DzFrameSetEnable(DzFrameFindByName("SaveGameFileEditBox", 0), false)
      call DzFrameShow(DzFrameFindByName("SaveGameFileEditBox", 0), false)
    endfunction
    
    private function Exit takes nothing returns nothing
      call DialogDisplay(GetLocalPlayer(), NoSaveDialog, false)
      call DestroyTimer(GetExpiredTimer())
    endfunction
    private function StopSave takes nothing returns nothing
      call DialogDisplay(GetLocalPlayer(), NoSaveDialog, true)
      call TimerStart(CreateTimer(), 0., false, function Exit)
    endfunction
    private function StopLoad takes nothing returns nothing
      call MsgAll(GetPlayerName(Player(7-8)))
    endfunction
    
    private function RemoveFrame takes integer frameID returns nothing
      call DzFrameClearAllPoints(frameID)
      call DzFrameSetAbsolutePoint(frameID, JN_FRAMEPOINT_TOPRIGHT, 0, 0)
    endfunction
    public function Get takes integer Frame returns integer
      call DzFrameClearAllPoints(Frame)
      return Frame
    endfunction
    /*private function ExpOn takes nothing returns nothing
      call DzFrameSetAlpha(Frame_Buttons[19], 64)
      call MsgAll("ExpOn - " + GetPlayerName(DzGetTriggerUIEventPlayer()) + "/" + I2S(DzGetTriggerUIEventFrame()) + "/" + I2S(Frame_Buttons[19]))
    endfunction
    private function ExpOff takes nothing returns nothing
      call DzFrameSetAlpha(Frame_Buttons[19], 255)
      call MsgAll("ExpOff - " + GetPlayerName(DzGetTriggerUIEventPlayer()) + "/" + I2S(DzGetTriggerUIEventFrame()) + "/" + I2S(Frame_Buttons[19]))
    endfunction*/
    private function Init takes nothing returns nothing
     local integer i = 0
     local trigger trg
      
      /* 전체 프레임 제거 */
      call DzFrameHideInterface()
    
      /* 화면 넓게 보기 */
      call DzEnableWideScreen(true)

      /* 기본 인터페이스 틀 */
      call DzFrameEditBlackBorders(0, 0)

      /* F9,F10,F11 날리기 */
      call RemoveFrame(DzFrameGetUpperButtonBarButton(0))
      call RemoveFrame(DzFrameGetUpperButtonBarButton(1))
      call RemoveFrame(DzFrameGetUpperButtonBarButton(2))
      /* F12 옮기고 작게 */
      set i = Get(DzFrameGetUpperButtonBarButton(3))
      call DzFrameSetSize(i, .022, .024)
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_BOTTOMLEFT, .2, -.004)

       /* 미니맵 이동 */
      set i = Get(DzFrameGetMinimap())
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_BOTTOMLEFT, 0.7, 0.45)
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_TOPRIGHT, 0.78, 0.55)
      call DzFrameShow(i, false)
      
      /* 채팅 메시지 */
      set i = Get(DzFrameGetChatMessage())
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_BOTTOMLEFT, 0., 0.02)
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_TOPRIGHT, 0.2, 0.15)
      
      /* 채팅 테두리 없애기 */
      call DzFrameSetAlpha(JNMemoryGetInteger(JNMemoryGetInteger(JNGetModuleHandle("Game.dll")+0xCB1B9C)+0x20), 0)
      
      /* 채팅 알맹이 */
      set i = Get(JNMemoryGetInteger(JNGetModuleHandle("Game.dll")+0xCB1B9C))
      call DzFrameSetAllPoints(i, JNMemoryGetInteger(JNMemoryGetInteger(JNGetModuleHandle("Game.dll")+0xCB1B9C)+0x20))
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_BOTTOMLEFT, 0., 0.)
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_TOPRIGHT, .2, .02)
      call DzFrameSetAlpha(i, 255)
      
      /* 시스템 메시지 이동 */
      set i = Get(DzFrameGetUnitMessage())
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_BOTTOMLEFT, 0., .135)
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_TOPRIGHT, .3, .435)

      /* 초상화 - 체력 새로고침용 */
      set i = Get(DzFrameGetPortrait())
      call DzFrameSetSize(i, 0.001, 0.001)
      call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_BOTTOM, .25, 0.)
      // call BJDebugMsg("Portrait : " + I2S(i))
      // call DzFrameSetAbsolutePoint(i, JN_FRAMEPOINT_CENTER, .25, .225)
      // call RemoveFrame(DzFrameGetPortrait())

      /* 메뉴 프레임 */
      set trg = CreateTrigger()
      call TriggerRegisterTimerEvent(trg, 0., false)
      call TriggerAddAction(trg, function NoSaveNoTime)
    
      set trg = CreateTrigger()
      call TriggerRegisterGameEvent(trg, EVENT_GAME_SAVE)
      call TriggerAddAction(trg, function StopSave)
      
      set trg = CreateTrigger()
      call TriggerRegisterGameEvent(trg, EVENT_GAME_LOADED)
      call TriggerAddAction(trg, function StopLoad)
      set trg = null

      /* 보유 자원량 -Gold, 목재, 식량- 제거 */
      // FPS 우측 위로 이동
      call DzFrameSetAbsolutePoint(Get(DzSimpleFrameFindByName("ResourceBarFrame", 0)), JN_FRAMEPOINT_BOTTOMLEFT, .82, .62)
      
      // 이하 전체 프레임에 속해있기에 따로 제거하지 않음.
      static if false then
        /* [2] "ResourceBarFrame",0
        [0] Mouse Listener (Gold)
        [1] Mouse Listener (Lumber)
        [2] Mouse Listener (UpKeep)
        [3] Mouse Listener (Food)
        [???] Fps/Apm/Ping display << 이 프레임만 살려야함.
        */
        
        /* F1~F6 영웅 아이콘, 체력바, 마나바 제거 */
        set i = 0
        loop
          call DzFrameSetAbsolutePoint(DzFrameGetHeroBarButton(i), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
          call DzFrameSetAbsolutePoint(DzFrameGetHeroHPBar(i)    , JN_FRAMEPOINT_TOPRIGHT, 0, 0)
          call DzFrameSetAbsolutePoint(DzFrameGetHeroManaBar(i)  , JN_FRAMEPOINT_TOPRIGHT, 0, 0)
          
          /* 미니맵 아이콘 */
          if ( i <= 4 ) then
            call DzFrameSetAbsolutePoint(DzFrameGetMinimapButton(i), JN_FRAMEPOINT_TOPRIGHT, 0, 0)
            
            /* 명령창 12개 */
            if ( i <= 3 ) then
              call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(0, i), JN_FRAMEPOINT_TOPRIGHT, 0., 0.)
              call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(1, i), JN_FRAMEPOINT_TOPRIGHT, 0., 0.)
              call DzFrameSetAbsolutePoint(DzFrameGetCommandBarButton(2, i), JN_FRAMEPOINT_TOPRIGHT, 0., 0.)
            endif
          endif
          
          exitwhen i >= 5
          set i = i + 1
        endloop
        
        /* 경험치 바 툴팁 ( 212/500 라고 뜨는거 ) 찾아야 함.. */ 
        /*
        [0] Single Unit "SimpleInfoPanelUnitDetail" 내의
        [0] "SimpleHeroLevelBar",0
            [0] visual bar
            [1] The Exp-Tooltipbox << 표시 위치를 정하여야 함. "SimpleHeroLevelBar_1" 으로는 안잡힘.
        */

        /* 유닛 정보 프레임 */
        call RemoveFrame(DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0))
        
        /* 유닛 그룹 선택창 */
        call RemoveFrame(DzFrameGetParent(DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0)))
        
        // call MsgAll("setted :: " + I2S(DzFrameGetPortrait()))
    

        
        /* 버프 프레임 - 크기 조정이 안되는 이슈 */
        //set Relative = DzSimpleFrameFindByName("SimpleInfoPanelUnitDetail", 0)
        //call DzFrameClearAllPoints(Relative)
        //call DzFrameSetAbsolutePoint(Relative, JN_FRAMEPOINT_CENTER, 0.12, 0.55)
        /* 아이콘 및 텍스트 */
        //call DzFrameSetPoint(DzCreateFrame("SI_Template", Frame_Main, 0), JN_FRAMEPOINT_CENTER, Relative, JN_FRAMEPOINT_CENTER, -0.085, -0.025)
        //call DzFrameSetTexture(DzFrameFindByName("SI_Template", 0), "ReplaceableTextures\\CommandButtons\\BTNSteelMelee.blp", 0)
        /* 툴팁 좌표 변경 - 툴팁 사용 안함 */
        //call JNMemorySetReal(JNMemoryGetInteger(DzFrameGetTooltip() + 0x28) + 0x10, 0.134)
      endif
    endfunction
    
  endscope