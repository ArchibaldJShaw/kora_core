return {
    CommandHelp = {
        addpermission = '授予玩家權限（僅限 God）', car = '生成載具（僅限管理員）', closeserver = '關閉伺服器，禁止無權限者進入（僅限管理員）', dv = '刪除載具（僅限管理員）', dvall = '刪除所有載具（僅限管理員）', dvo = '刪除所有物件（僅限管理員）', dvp = '刪除所有 NPC（僅限管理員）', gang = '查看你的幫派', givemoney = '給玩家發錢（僅限管理員）', job = '查看你的工作', me = '顯示本地訊息', ooc = 'OOC 聊天訊息', openserver = '向所有人開放伺服器（僅限管理員）', removepermission = '移除玩家權限（僅限 God）', setgang = '設定玩家幫派（僅限管理員）', setjob = '設定玩家工作（僅限管理員）', setmoney = '設定玩家金額（僅限管理員）', togglepvp = '切換伺服器 PVP（僅限管理員）', tp = '傳送到玩家或座標（僅限管理員）', tpm = '傳送到標記點（僅限管理員）',
    },
    CommandParams = {
        amount_of_money = '金額', gang_grade = '幫派等級', gang_name = '幫派名稱', id_of_player = '玩家 ID', id_of_player_or_x_position = '玩家 ID 或 X 座標', job_grade = '工作等級', job_name = '工作名稱', message_to_send = '要傳送的訊息', model_name_of_the_vehicle = '載具模型名稱', permission_level = '權限等級', player_id = '玩家 ID', reason_for_closing_optional = '關閉原因（選填）', type_of_money_cash_bank_crypto = '貨幣類型（cash、bank、crypto）', y_position = 'Y 座標', z_position = 'Z 座標',
    },
    Commands = {
        account_choices = '貨幣類型必須是以下其中一種：%s', already_closed = '伺服器已經關閉', already_open = '伺服器已經開啟', closed = '伺服器已關閉', coordinates_required = '未輸入所有參數（x、y、z）', deleted_entities = '已刪除 %d 個實體', gang_status = '幫派：%s | 等級：%s', give_money_failed = '無法發放金錢：%s', grade_invalid = '等級必須是大於或等於 0 的整數', incorrect_format = '格式不正確', job_status = '工作：%s | 等級：%s | 值勤：%s', kick_permission_denied = '你沒有此權限..', location_missing = '地點不存在', no_reason = '未提供原因', ooc_prefix = 'OOC | ', ooc_proximity_prefix = '附近 OOC | ', opened = '伺服器已開啟', permission_choices = '權限必須是以下其中一種：%s', permission_denied = '你沒有使用此指令的權限。', permission_granted = '已授予玩家 %s 權限 %d', permission_removed = '已移除玩家 %s 的權限 %d', player_offline = '玩家不在線上', player_required = '此指令必須由遊戲中的玩家使用。', pvp_disabled = 'PVP 已關閉', pvp_enabled = 'PVP 已開啟', server_closed = '伺服器已關閉', set_money_failed = '無法設定金錢：%s', set_role_failed = '無法設定 %s：%s',
    },
    Connection = { disconnected = '已中斷連線。' },
    Inventory = { item = '物品', received = '已收到 %dx %s', removed = '已移除 %dx %s' },
    Jail = { id_help = '玩家伺服器 ID', jail_help = '監禁玩家', jailed = '你已被監禁 %d 分鐘。', minutes_help = '監禁時間（分鐘）', reason_help = '原因（選填）', release_help = '釋放被監禁的玩家', released = '你已獲釋。' },
    Language = { changed = '語言已設為 %s。', current = '目前語言', open_selector = '開啟語言選擇器', title = '語言' },
    Notify = { arguments_required = '必須填寫所有參數！', command_denied = '無權使用此指令', duty_off = '你現在已下班！', duty_on = '你現在正在值勤！', locale_invalid = '無效的本地化參照。', placeholder = '佔位符', stress_decreased = '感覺放鬆多了！', stress_increased = '感覺壓力更大了！', vehicle_spawn_failed = '無法生成該載具', waypoint_failed = '無法傳送至航點', waypoint_missing = '尚未設定航點', waypoint_start_failed = '無法開始航點傳送', waypoint_success = '已傳送至航點' },
}
