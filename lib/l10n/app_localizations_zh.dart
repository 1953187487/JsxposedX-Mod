// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appName => 'JSXPOSEDX';

  @override
  String get desktopNavDeviceConnection => '设备连接';

  @override
  String get desktopNavWorkbench => '工作台';

  @override
  String get desktopNavSettings => '设置';

  @override
  String get desktopThemeSwitchToLight => '浅色模式';

  @override
  String get desktopThemeSwitchToDark => '深色模式';

  @override
  String get desktopFeatureTodo => '功能待实现';

  @override
  String get desktopUpdateCheck => '检查更新';

  @override
  String get desktopUpdateCheckDescription => '检查 JsxposedX 是否有新版本';

  @override
  String desktopCurrentVersion(String version, String buildNumber) {
    return '当前版本 $version ($buildNumber)';
  }

  @override
  String get desktopUpdateLatest => '当前已是最新版本';

  @override
  String get desktopUpdateCheckFailed => '检查更新失败，请稍后重试';

  @override
  String get desktopConnectionConnected => '已连接';

  @override
  String get homeDesktopCardTitle => '电脑连接';

  @override
  String get homeDesktopCardDisconnected => '等待电脑端连接';

  @override
  String homeDesktopCardDeviceCount(int count) {
    return '$count 台设备';
  }

  @override
  String get desktopConnectionConnecting => '连接中…';

  @override
  String get desktopConnectionDisconnected => '未连接';

  @override
  String desktopConnectionAdbActive(String device) {
    return '已通过 ADB 连接 $device';
  }

  @override
  String get desktopConnectionConnect => '连接';

  @override
  String get desktopConnectionDisconnect => '断开';

  @override
  String get desktopConnectionAddressHint => '手机端地址';

  @override
  String get desktopConnectionAdb => 'ADB';

  @override
  String get desktopConnectionWifi => 'Wi-Fi';

  @override
  String get desktopConnectionRefresh => '刷新设备';

  @override
  String get desktopConnectionDeviceUnauthorized => '设备未授权，请在手机上允许 USB 调试';

  @override
  String get desktopDeviceListTitle => '设备列表';

  @override
  String get desktopDeviceListEmpty => '未发现设备，请连接手机或点击刷新';

  @override
  String get desktopConnectionPairAddressHint => '配对地址，例如 192.168.1.2:37099';

  @override
  String get desktopConnectionPairCodeHint => '配对码';

  @override
  String get desktopConnectionPair => '配对';

  @override
  String get desktopConnectionAdbAddressHint => '连接地址，例如 192.168.1.2:5555';

  @override
  String get desktopConnectionAdbConnect => '连接 ADB';

  @override
  String get desktopConnectionAdbSettings => 'ADB 设置';

  @override
  String get desktopConnectionConfigureAdb => '配置 ADB 配对与无线连接';

  @override
  String get desktopConnectionConnectAdb => '通过 ADB 连接';

  @override
  String get desktopConnectionConnectWifi => '通过 Wi-Fi 连接';

  @override
  String get desktopConnectionPairSection => '无线调试配对';

  @override
  String get desktopConnectionWirelessSection => '无线连接';

  @override
  String get desktopConnectionPairNextStep =>
      '配对成功。配对不会让设备直接出现在列表中，请在手机无线调试页面查看“IP 地址和端口”，填入下方连接地址后点击“连接 ADB”。注意：连接端口通常与配对端口不同。';

  @override
  String get desktopSettingsAppearance => '外观';

  @override
  String get desktopSettingsColorTheme => '颜色主题';

  @override
  String get desktopSettingsThemeDark => '深色';

  @override
  String get desktopSettingsThemeLight => '浅色';

  @override
  String get desktopSettingsDisplayLanguage => '显示语言';

  @override
  String get desktopSettingsApplication => '应用';

  @override
  String get desktopSettingsCommunity => '社区';

  @override
  String get desktopSettingsCommunityDescription => '获取教程与社区支持';

  @override
  String get desktopSettingsCommunityForum => '沐雪 AI';

  @override
  String get desktopSettingsOfficialMirror => '官方中转站';

  @override
  String get desktopSettingsJoinDiscord => '加入 Discord';

  @override
  String get desktopSettingsJoinQQGroup => '加入 QQ 群';

  @override
  String get desktopSettingsTargetRange => '靶场';

  @override
  String get desktopSettingsFollowAuthor => '关注作者';

  @override
  String get desktopSettingsMorePlatforms => '查看更多平台';

  @override
  String get desktopSettingsAbout => '关于';

  @override
  String get desktopSettingsOfficialSite => '官网';

  @override
  String get desktopSettingsOfficialSiteHint => '获取最新教程';

  @override
  String get desktopSettingsRepository => '仓库';

  @override
  String get desktopSettingsWechat => '微信公众号';

  @override
  String get desktopDeviceDefaultName => 'Android 设备';

  @override
  String desktopDeviceSummary(String manufacturer, String api, String abi) {
    return '$manufacturer · API $api · $abi';
  }

  @override
  String get desktopDeviceCapabilities => '设备能力';

  @override
  String get desktopExplorerTitle => '资源管理器';

  @override
  String get desktopExplorerNewScript => '新建脚本';

  @override
  String get desktopExplorerLocalScripts => '本地脚本';

  @override
  String get desktopExplorerDescription => '脚本保存在电脑本地，并在所选设备上运行。';

  @override
  String get desktopExplorerFridaScripts => 'Frida 脚本';

  @override
  String get desktopExplorerXposedScripts => 'Xposed 脚本';

  @override
  String get desktopExplorerNoScripts => '暂无脚本';

  @override
  String get desktopEditorSaveAndRun => '保存并运行（Ctrl/Cmd+S）';

  @override
  String get desktopEditorRunning => '已保存并在设备上运行';

  @override
  String get desktopEditorRestartApp => '保存后重启目标应用';

  @override
  String get desktopEditorRunScript => '在设备上运行此脚本';

  @override
  String get desktopEditorOptions => '脚本设置';

  @override
  String get desktopEditorUntitled => '未选择脚本';

  @override
  String get desktopEditorLoadFailed => '脚本读取失败';

  @override
  String get desktopEditorCreateScript => '新建或打开本地脚本';

  @override
  String get desktopEditorConnectDevice => '连接设备后开始';

  @override
  String get desktopEditorDescription => '脚本保留在电脑中，并同步到所选设备执行。';

  @override
  String get desktopOutputTitle => '输出';

  @override
  String get desktopOutputEmpty => '运行日志将实时显示在此处。';

  @override
  String desktopOutputRequestCompleted(String requestId) {
    return '请求 $requestId 已完成';
  }

  @override
  String get desktopOutputExpand => '展开输出面板';

  @override
  String get desktopOutputCollapse => '收起输出面板';

  @override
  String get desktopShellHint => '输入 shell 命令，↑ 切换历史';

  @override
  String get desktopShellSuTooltip => '以 su（root）执行';

  @override
  String get desktopShellRunTooltip => '执行命令';

  @override
  String get desktopShellStatusNoDevice => '未连接设备，无法执行命令';

  @override
  String get desktopShellDisconnected => '与设备的连接已断开';

  @override
  String get desktopShellSessionClosed => '会话已结束';

  @override
  String get desktopConsoleLogs => '日志';

  @override
  String get desktopConsoleTerminal => '终端';

  @override
  String get desktopStatusNoDevice => '未连接设备';

  @override
  String get desktopStatusQuickConnect => '刷新并自动连接';

  @override
  String get desktopStatusConnecting => '连接中…';

  @override
  String desktopStatusDeviceInfo(String api, String abi) {
    return 'API $api · $abi';
  }

  @override
  String get appSubtitle => '基于 Xposed Frida 的跨平台Hook调试工具';

  @override
  String get home => '首页';

  @override
  String get project => '项目';

  @override
  String get repository => '仓库';

  @override
  String get news => '最新';

  @override
  String get star => '收藏';

  @override
  String get repositoryAccountInfo => '账号信息';

  @override
  String get repositoryTokenLogin => 'Token 登录';

  @override
  String get repositoryReplaceToken => '更换 Token';

  @override
  String get repositoryTokenHint => '请输入 Token';

  @override
  String get repositoryTokenEmpty => 'Token 不能为空';

  @override
  String get repositoryVerifyAndLogin => '验证并登录';

  @override
  String get repositoryTokenLoginSuccess => 'Token 登录成功';

  @override
  String get repositoryTokenInvalid => 'Token 无效或已失效';

  @override
  String get repositoryUnnamedUser => '未命名用户';

  @override
  String get repositoryMxid => 'MXID';

  @override
  String get repositoryVip => 'VIP';

  @override
  String get repositoryVipActive => '已开通';

  @override
  String get repositoryVipInactive => '未开通';

  @override
  String get repositoryFavoriteLoginRequired => '请先登录';

  @override
  String get repositoryFavoriteLoginHint => '登录后才能查看收藏内容';

  @override
  String get settings => '设置';

  @override
  String get language => '语言';

  @override
  String get theme => '主题';

  @override
  String get lightTheme => '浅色主题';

  @override
  String get darkTheme => '深色主题';

  @override
  String get chinese => '简体中文';

  @override
  String get english => 'English';

  @override
  String get confirm => '确认';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get delete => '删除';

  @override
  String get edit => '编辑';

  @override
  String get add => '添加';

  @override
  String get refresh => '刷新';

  @override
  String get search => '搜索';

  @override
  String get loading => '加载中...';

  @override
  String get success => '成功';

  @override
  String get error => '错误';

  @override
  String get warning => '警告';

  @override
  String get info => '信息';

  @override
  String get hookStatus => 'Hook 状态';

  @override
  String get hookEnabled => 'Hook 已启用';

  @override
  String get hookDisabled => 'Hook 未启用';

  @override
  String get moduleInfo => '模块信息';

  @override
  String get version => '版本';

  @override
  String get about => '关于';

  @override
  String get disclaimer => '免责声明';

  @override
  String get disclaimerSubtitle => '合法用途、AI 输出与责任说明';

  @override
  String get disclaimerDialogIntro => '以下内容提取自项目 README，继续使用本项目即视为已阅读并同意本声明。';

  @override
  String get disclaimerLegalTitle => '合法用途';

  @override
  String get disclaimerLegalBody =>
      '本项目为开源技术研究工具，仅用于软件调试、程序分析、内存机制学习、开发测试及授权环境研究等合法用途。作者公开本项目旨在促进技术交流与学习，不针对任何特定游戏、平台、软件或在线服务，不提供作弊、绕过保护或违规使用指导。';

  @override
  String get disclaimerProhibitedTitle => '禁止用途';

  @override
  String get disclaimerProhibitedBody =>
      '严禁用于网络游戏作弊、外挂制作、自动化违规操作、干扰服务器或客户端正常运行、未经授权修改第三方程序数据、破坏公平竞争环境，或任何违反法律法规及平台规则的用途。';

  @override
  String get disclaimerResponsibilityTitle => '责任归属';

  @override
  String get disclaimerResponsibilityBody =>
      '使用者应自行确保使用行为符合所在地法律法规及相关服务条款。因使用、传播、二次开发本项目产生的任何直接或间接后果，由使用者自行承担，与作者无关。';

  @override
  String get disclaimerAiTitle => 'AI 功能说明';

  @override
  String get disclaimerAiBody =>
      '内置 AI 功能仅作为通用智能辅助模块，用于数据分析、内容解释、结果筛选、信息整理、操作指引及学习研究等场景。AI 输出可能存在误差、遗漏或不适用于特定场景，仅供参考；用户应自行判断并承担最终使用责任。';

  @override
  String get community => '社区';

  @override
  String get officialCommunity => '获取教程与社区支持';

  @override
  String get forum => '论坛';

  @override
  String get visitForum => '进入沐雪 AI';

  @override
  String get joinDiscord => '加入 Discord';

  @override
  String get joinQQGroup => '加入 QQ 群';

  @override
  String get targetRange => '靶场';

  @override
  String get followAuthor => '关注作者';

  @override
  String get creatorPlatforms => '获取教程';

  @override
  String get morePlatforms => '查看更多平台';

  @override
  String pageNotFound(String error) {
    return '页面未找到: $error';
  }

  @override
  String get backToHome => '返回首页';

  @override
  String get retry => '重试';

  @override
  String get loadFailedMessage => '加载失败，请重试';

  @override
  String get activated => '已激活';

  @override
  String get notActivated => '未激活';

  @override
  String get fridaPartial => '局部';

  @override
  String get fridaGlobal => '全局';

  @override
  String get fridaUnknown => '未知';

  @override
  String get fridaNotInstalledShort => '未安装';

  @override
  String get fridaInitAbnormal => '初始化异常';

  @override
  String get fridaStatusEnabled => '已启用';

  @override
  String get fridaStatusDisabled => '已禁用';

  @override
  String get fridaTargetDisabled => '目标关闭';

  @override
  String get fridaEffective => '已生效';

  @override
  String get zygiskFridaModuleNotInstalled => 'Zygisk Frida 模块未安装';

  @override
  String get systemVersion => '系统版本';

  @override
  String get sdkVersion => 'SDK版本';

  @override
  String get deviceModel => '设备型号';

  @override
  String get systemStorage => '系统存储';

  @override
  String get cpuArchitecture => 'CPU架构';

  @override
  String get frameworkPackageName => '框架包名';

  @override
  String get copy => '复制';

  @override
  String get selectAll => '全选';

  @override
  String get cut => '剪切';

  @override
  String get paste => '粘贴';

  @override
  String get comment => '注释';

  @override
  String get codeCopied => '代码已复制到剪贴板';

  @override
  String get totalStorage => '总存';

  @override
  String get available => '可用';

  @override
  String get softwareIcon => '软件图标';

  @override
  String get needRootPermission => '你必须授予Root权限';

  @override
  String get pleaseActivateXposed => '请先激活Xposed,随意勾选一个模块即可';

  @override
  String get initFrida => '初始化Frida';

  @override
  String get homeTitleAI => 'AI';

  @override
  String get homeTitleRoot => 'Root';

  @override
  String get homeTitleXposed => 'Xposed';

  @override
  String get homeTitleFrida => 'Frida';

  @override
  String get themeColor => '主题配色';

  @override
  String get selectThemeColor => '选择皮肤颜色';

  @override
  String get aiConfig => 'AI 配置';

  @override
  String get aiConfigTitle => 'AI 设置';

  @override
  String get aiBaseUrl => 'API 地址';

  @override
  String get aiBaseUrlHint => '请输入 API 地址';

  @override
  String get aiApiKeyHint => '请输入 API Key';

  @override
  String get aiMaxTokens => '最大 Token';

  @override
  String get aiMaxTokensHint => '请输入最大 Token 数量';

  @override
  String get aiModelName => '模型名称';

  @override
  String get aiModelNameHint => '请输入模型名称';

  @override
  String get aiTemperature => '温度 (Temperature)';

  @override
  String get aiMemoryRounds => '对话记忆轮数';

  @override
  String cannotBeEmpty(Object field) {
    return '$field不能为空';
  }

  @override
  String get saveSuccess => '保存成功';

  @override
  String get test => '测试';

  @override
  String get selectApp => '选择应用';

  @override
  String get showSystemApps => '显示系统应用';

  @override
  String get searchAppsPlaceholder => '全局搜索应用名称或包名...';

  @override
  String loadedCount(int loaded, int total) {
    return '加载: $loaded / 符合: $total';
  }

  @override
  String get systemAppLabel => '系统';

  @override
  String alreadySelected(Object name) {
    return '已选择: $name';
  }

  @override
  String get notice => '公告';

  @override
  String get updateAvailableTitle => '发现新版本';

  @override
  String get updateContentTitle => '更新内容';

  @override
  String get updateNow => '立即更新';

  @override
  String get updateContentFallback => '• 修复已知问题\n• 优化用户体验\n• 提升应用性能';

  @override
  String get noRelatedApps => '没有找到相关应用';

  @override
  String get projectListEmpty => '暂无项目，去首页创建一个吧';

  @override
  String projectLoadFailed(Object error) {
    return '加载失败: $error';
  }

  @override
  String get confirmDelete => '确认删除?';

  @override
  String get xposedProject => 'Xposed 项目';

  @override
  String get fridaProject => 'Frida 项目';

  @override
  String get quickFunctions => '快捷功能';

  @override
  String get aiReverse => 'AI 逆向';

  @override
  String get qfPageTitle => '快捷功能';

  @override
  String get qfSectionBasic => '基础功能';

  @override
  String get qfSectionEnv => '环境功能';

  @override
  String get qfSectionCrypto => '加密分析';

  @override
  String get qfRemoveDialogs => '去除弹窗';

  @override
  String get qfRemoveScreenshotDetection => '去除截屏/录屏检测';

  @override
  String get qfRemoveCaptureDetection => '去除抓包检测';

  @override
  String get qfInjectTip => '注入提示';

  @override
  String get qfModifiedVersion => '去除更新';

  @override
  String get qfHideXposed => '隐藏 Xposed';

  @override
  String get qfHideRoot => '隐藏 Root';

  @override
  String get qfHideApps => '隐藏应用列表';

  @override
  String get qfAlgorithmicTracking => '算法追踪';

  @override
  String get keywordManagement => '关键词管理';

  @override
  String get addKeyword => '添加关键词';

  @override
  String get keywordPlaceholder => '输入关键词...';

  @override
  String get noKeywords => '暂无关键词';

  @override
  String get noData => '暂无数据';

  @override
  String get encrypt => '加密';

  @override
  String get decrypt => '解密';

  @override
  String get detailInfo => '详情信息';

  @override
  String get inputLabel => '输入';

  @override
  String get outputLabel => '输出';

  @override
  String get algorithmLabel => '算法';

  @override
  String get keyLabel => '密钥';

  @override
  String get ivLabel => 'IV 向量';

  @override
  String get stackLabel => '方法堆栈';

  @override
  String get plaintextLabel => '明文';

  @override
  String get hexLabel => 'HEX';

  @override
  String get base64Label => 'Base64';

  @override
  String get fingerprintLabel => '指纹';

  @override
  String get clear => '清空';

  @override
  String get clearConfirm => '确定要清空所有算法追踪日志吗？此操作不可恢复。';

  @override
  String get searchPlaceholder => '搜索算法、内容或堆栈...';

  @override
  String get visualRulesTab => '可视化规则 (Visual)';

  @override
  String get codeSourceTab => '底层源码 (Code)';

  @override
  String get noVisualRules => '暂无可视化规则';

  @override
  String get addRuleBtn => '添加新拦截规则';

  @override
  String get ruleConfig => '拦截配置项';

  @override
  String get targetFingerprint => '目标指纹 (Fingerprint)';

  @override
  String get interceptDirection => '拦截方向 (Direction)';

  @override
  String get directionInput => '加密前 (Input)';

  @override
  String get directionOutput => '解密后 (Output)';

  @override
  String get specifyAlgorithm => '指定算法 (可选)';

  @override
  String get anyAlgorithm => '全部算法 (Any)';

  @override
  String get replaceData => '替换为 (明文)';

  @override
  String get replaceDataHint => '填入你期望篡改的数据...';

  @override
  String get aiNotActivated => 'AI未激活，请先配置AI大模型';

  @override
  String get aiSwitchSession => '切换会话';

  @override
  String get aiNewSession => '新建会话';

  @override
  String get aiSessionName => '会话名称';

  @override
  String get aiSessionNameHint => '请输入会话名称...';

  @override
  String get aiDeleteHistory => '清除历史';

  @override
  String get aiDeleteConfirmTitle => '确认删除';

  @override
  String get aiDeleteConfirmContent => '这将永久删除该应用的所有聊天记录，确定吗？';

  @override
  String get aiIdentifying => '正在识别...';

  @override
  String get aiGetInfo => '正在获取信息...';

  @override
  String get aiChatInputHint => '有问题尽管问我...';

  @override
  String get aiReverseSessionInitializingHint => '逆向会话初始化中…';

  @override
  String get aiReverseSessionInitFailedHint => '逆向会话初始化失败，当前不可发送';

  @override
  String get aiReverseSessionInitializingBanner => '逆向会话初始化中，完成前将阻止发送。';

  @override
  String get aiReverseSessionInitFailedBanner => '逆向会话初始化失败，当前不可发送。';

  @override
  String get aiStopGeneration => '停止生成';

  @override
  String get aiCompressContext => '压缩上下文';

  @override
  String get aiContext => '上下文';

  @override
  String get aiContextTitle => '上下文';

  @override
  String get aiContextBudget => '上下文预算';

  @override
  String get aiContextUsage => '占用率';

  @override
  String get aiContextMemoryEntries => '记忆条目';

  @override
  String get aiContextHighWatermark => '高水位';

  @override
  String get aiContextHighWatermarkReached => '已触发';

  @override
  String get aiContextHighWatermarkNotReached => '未触发';

  @override
  String get aiContextHighWatermarkAlert => '上下文接近容量上限，已自动压缩历史摘要';

  @override
  String get aiContextRemaining => '剩余预算';

  @override
  String get aiContextLayers => '装配层';

  @override
  String get aiContextRecentRounds => '最近原始轮次';

  @override
  String get aiContextCheckpoint => '最近检查点';

  @override
  String get aiContextNoCheckpoint => '暂无检查点';

  @override
  String get aiContextCheckpointTime => '更新时间';

  @override
  String get aiContextCheckpointPrompt => '最近用户输入';

  @override
  String get aiContextCheckpointMode => '恢复模式';

  @override
  String get aiContextLastError => '最近错误';

  @override
  String get aiContextNoError => '暂无错误';

  @override
  String get aiContextMigration => '会话迁移';

  @override
  String get aiContextMigrationDone => '已从旧会话迁移';

  @override
  String get aiContextMigrationNone => '当前会话已使用新结构';

  @override
  String get aiContextCompression => '压缩状态';

  @override
  String get aiContextCompactReasonBudget => '达到预算上限';

  @override
  String get aiContextCompactReasonManual => '手动压缩';

  @override
  String get aiContextCompactReasonNone => '未触发压缩';

  @override
  String get aiContextToolTrace => '工具轨迹';

  @override
  String get aiContextToolTracePending => '存在未完成工具阶段';

  @override
  String get aiContextToolTraceClear => '工具链完整';

  @override
  String get aiContextMemory => '结构化摘要';

  @override
  String get aiContextGoals => '用户目标';

  @override
  String get aiContextFacts => '已确认事实';

  @override
  String get aiContextHypotheses => '未确认假设';

  @override
  String get aiContextFindings => '工具发现';

  @override
  String get aiContextTaskCurrent => '当前步骤';

  @override
  String get aiContextTaskNext => '下一步';

  @override
  String get aiContextTaskBlockers => '阻塞/错误';

  @override
  String get aiViewSummary => '查看摘要';

  @override
  String get aiSummaryTitle => '会话摘要';

  @override
  String get aiSummaryEmpty => '当前还没有可展示的摘要内容';

  @override
  String get aiContextCompressed => '已压缩上下文';

  @override
  String get aiContextAlreadyCompact => '当前上下文已经较精简';

  @override
  String get aiRetryLastTurn => '重试上一轮';

  @override
  String get aiRetryInitialization => '重试初始化';

  @override
  String get aiContinue => '继续';

  @override
  String get aiResumeToolPhase => '恢复工具阶段';

  @override
  String get aiRecoveryModeRetry => '重试上一轮';

  @override
  String get aiRecoveryModeContinue => '继续生成';

  @override
  String get aiRecoveryModeTool => '恢复工具阶段';

  @override
  String get aiUnavailableToSend => '不可发送';

  @override
  String get aiReverseTabChat => '对话';

  @override
  String get aiReverseTabAnalysis => '分析';

  @override
  String get aiReverseOpenAnalysis => 'APK目录';

  @override
  String get aiReverseBackToChat => '返回对话';

  @override
  String get aiAssistantTitle => '我是你的 AI 逆向助手';

  @override
  String get aiAssistantSubtitle => '您可以询问清单分析、加固检测等专业问题';

  @override
  String get aiMessageSendFailed => '消息发送失败，请检查网络或配置';

  @override
  String get aiCodeCopied => '代码已复制到剪贴板';

  @override
  String get aiOneClickCopy => '一键复制';

  @override
  String get aiBubbleActionsTitle => '气泡操作';

  @override
  String get aiBubbleCopyCurrent => '复制当前内容';

  @override
  String get aiBubbleSelectText => '选择文本';

  @override
  String get aiBubbleUserTextTitle => '用户消息';

  @override
  String get aiBubbleAssistantTextTitle => 'AI 回复';

  @override
  String get aiBubbleThinkingTitle => '思考过程';

  @override
  String get aiBubbleAnswerTitle => '回答内容';

  @override
  String get aiTestConnecting => '正在测试连接...';

  @override
  String aiTestSuccess(Object result) {
    return '测试成功！收到回复: \n$result';
  }

  @override
  String aiTestFailed(Object error) {
    return '测试失败: $error';
  }

  @override
  String get aiSavingAndTesting => '正在保存并测试连通性...';

  @override
  String aiSaveFailed(Object error) {
    return '配置保存失败（连接测试未通过）: \n$error';
  }

  @override
  String aiShowMoreMessages(Object count) {
    return '显示更早的消息 ($count)';
  }

  @override
  String get aiSearchInConversation => '搜索当前会话';

  @override
  String get aiSearchMessagesHint => '搜索消息内容...';

  @override
  String get aiSearchNoResults => '没有找到匹配的消息';

  @override
  String aiSearchResultCount(int count) {
    return '$count 条匹配';
  }

  @override
  String get aiSearchRoleUser => '我';

  @override
  String get aiSearchRoleAssistant => 'AI';

  @override
  String get aiSearchRoleSystem => '系统';

  @override
  String get aiSearchRoleTool => '工具';

  @override
  String get aiSearchMessageNotFound => '该消息不在当前已加载的会话中';

  @override
  String aiToolUnknown(String toolName) {
    return '未知工具: $toolName';
  }

  @override
  String get aiToolCallFailed => '工具调用失败，请发送关键词\"继续\"重试';

  @override
  String get aiToolCalling => '正在调用工具...';

  @override
  String aiToolReading(String toolName) {
    return '正在读取 $toolName...';
  }

  @override
  String get aiToolNameManifest => '清单';

  @override
  String get aiToolNameDecompile => '反编译';

  @override
  String get aiToolNameSmali => 'Smali';

  @override
  String get aiToolNameSearch => '搜索';

  @override
  String get aiToolNamePackages => '包信息';

  @override
  String get aiToolNameClasses => '类信息';

  @override
  String get aiContinueKeyword => '继续';

  @override
  String get projectCreate => '创建';

  @override
  String projectCreated(Object name) {
    return '项目已创建: $name';
  }

  @override
  String get projectName => '项目名称';

  @override
  String get projectNameHint => '请输入项目名称';

  @override
  String get projectType => '项目类型';

  @override
  String get newProject => '创建项目';

  @override
  String get visualType => '可视化';

  @override
  String get traditionalType => '传统';

  @override
  String get xposedScripts => 'Xposed 脚本列表';

  @override
  String get projectNameEmpty => '项目名称不能为空';

  @override
  String get formatCode => '格式化代码';

  @override
  String get find => '查找';

  @override
  String get replace => '替换';

  @override
  String get replaceWith => '替换为...';

  @override
  String get matchCase => '区分大小写';

  @override
  String get regex => '正则表达式';

  @override
  String get prevMatch => '上一个';

  @override
  String get nextMatch => '下一个';

  @override
  String get close => '关闭';

  @override
  String get replaceAll => '全部替换';

  @override
  String get searchCode => '搜索代码...';

  @override
  String get toggleReplace => '切换替换模式';

  @override
  String get aiConfigList => '配置列表';

  @override
  String get aiConfigNew => '新建';

  @override
  String get aiConfigCurrent => '当前';

  @override
  String get aiConfigEmpty => '暂无配置，请填写下方表单保存';

  @override
  String get aiConfigEditTitle => '编辑配置';

  @override
  String get aiConfigNewTitle => '新建配置';

  @override
  String get aiConfigName => '配置名称';

  @override
  String get aiConfigNameHint => '例如：OpenAI GPT-4';

  @override
  String get aiConfigSwitch => '切换到此配置';

  @override
  String get aiConfigDelete => '删除配置';

  @override
  String aiConfigDeleteConfirm(String name) {
    return '确认删除 \'$name\' 配置？';
  }

  @override
  String get aiApiType => 'API 类型';

  @override
  String get aiApiTypeOpenAI => 'OpenAI';

  @override
  String get aiApiTypeOpenAIResponses => 'OpenAI Responses';

  @override
  String get aiApiTypeAnthropic => 'Anthropic Claude';

  @override
  String get aiTutorial => '教程';

  @override
  String get aiBuiltinConfigName => '沐雪接口';

  @override
  String get aiBuiltinUseConfig => '使用沐雪接口';

  @override
  String get aiBuiltinSwitching => '正在切换到沐雪内置接口';

  @override
  String get aiBuyCardSecret => '购买卡密';

  @override
  String get aiApiKeyConfigured => 'API Key 已配置';

  @override
  String get aiApiKeyNotConfigured => 'API Key 未配置';

  @override
  String aiCurrentStatus(String status) {
    return '当前状态：$status';
  }

  @override
  String aiCurrentInterface(String name) {
    return '当前接口：$name';
  }

  @override
  String get terminal => '控制台';

  @override
  String get terminalFilterHint => '二次过滤...';

  @override
  String get autoScroll => '自动滚屏';

  @override
  String get clearPanel => '清空视图';

  @override
  String get consoleClearViewTooltip => '仅清空当前视图，已持久化的日志不受影响';

  @override
  String get noLogs => '暂无日志';

  @override
  String get noLogsFiltered => '过滤后无匹配';

  @override
  String get logcatFullscreen => '全屏';

  @override
  String get consoleSourceSession => '会话';

  @override
  String get consoleSourceFrida => 'Frida';

  @override
  String get consoleSourceXposed => 'Xposed';

  @override
  String get consoleSourceApp => '应用';

  @override
  String get consoleSourceCore => '核心';

  @override
  String get consoleSourceSystem => '系统';

  @override
  String get consoleLevelDebug => '调试';

  @override
  String get consoleLevelInfo => '信息';

  @override
  String get consoleLevelWarn => '警告';

  @override
  String get consoleLevelError => '错误';

  @override
  String get consoleAll => '全部';

  @override
  String get consoleHistory => '持久化脚本日志';

  @override
  String get consolePauseOutput => '暂停输出';

  @override
  String get consoleResumeOutput => '继续输出';

  @override
  String get consoleActions => '控制台操作';

  @override
  String get consoleCopyVisible => '复制可见日志';

  @override
  String get consoleExportVisible => '导出可见日志';

  @override
  String consoleCopied(Object count) {
    return '已复制 $count 条日志';
  }

  @override
  String consoleCopiedTruncated(Object count, Object total) {
    return '日志过多，已复制最近 $count 条（共 $total 条），完整内容请用导出';
  }

  @override
  String get consoleRegexSearch => '正则检索';

  @override
  String get consoleCaseSensitive => '区分大小写';

  @override
  String get consoleExpandStack => '展开堆栈';

  @override
  String get consoleCollapseStack => '收起堆栈';

  @override
  String get consoleExportDialogTitle => '导出控制台日志';

  @override
  String get consoleNoHistory => '暂无持久化脚本日志';

  @override
  String get consoleLiveBelow => '以下为实时输出';

  @override
  String get consoleLoadOlder => '加载更早日志';

  @override
  String get consoleLogCopied => '日志已复制';

  @override
  String get consoleDeleteHistory => '删除该会话历史日志';

  @override
  String get consoleDeleteHistoryConfirmTitle => '删除历史日志？';

  @override
  String get consoleDeleteHistoryConfirmMessage =>
      '将永久删除当前会话已持久化的脚本日志，该操作不可撤销。';

  @override
  String get consoleDeleteHistoryDone => '已删除该会话的历史日志';

  @override
  String get consoleDeleteHistoryUnavailable => '当前会话没有关联的持久化记录';

  @override
  String get apiManual => '手册';

  @override
  String get aiApiManualTitle => 'API AI 助手';

  @override
  String get aiApiManualSubtitle => '向我提问 JsxposedX API 用法';

  @override
  String get visualEditorTab => '可视化';

  @override
  String get codeEditorTab => '代码';

  @override
  String get addBlock => '添加 Block';

  @override
  String get noBlocks => '暂无 Hook Block';

  @override
  String get noBlocksHint => '点击下方按钮添加第一个 Block';

  @override
  String get blockHookMethod => 'Hook 方法';

  @override
  String get blockHookMethodDesc => 'Hook 一个方法，支持 before/after/replace 回调';

  @override
  String get blockHookConstructor => 'Hook 构造函数';

  @override
  String get blockHookConstructorDesc => 'Hook 一个类的构造函数';

  @override
  String get blockReturnConst => '返回常量';

  @override
  String get blockReturnConstDesc => '强制方法返回一个固定值';

  @override
  String get blockLogParams => '打印参数';

  @override
  String get blockLogParamsDesc => '打印方法的所有参数和返回值';

  @override
  String get blockSetField => '修改字段';

  @override
  String get blockSetFieldDesc => '修改字段值（静态或实例）';

  @override
  String get blockCustomCode => '自定义代码';

  @override
  String get blockCustomCodeDesc => '编写自由 JavaScript 代码';

  @override
  String get blockClassName => '类名';

  @override
  String get blockClassNameHint => '如 com.example.MyClass';

  @override
  String get blockMethodName => '方法名';

  @override
  String get blockMethodNameHint => '如 login';

  @override
  String get blockParamTypes => '参数类型';

  @override
  String get blockParamTypesHint => '逗号分隔，如 int, java.lang.String, boolean';

  @override
  String get blockTiming => '时机';

  @override
  String get blockTimingBefore => '之前';

  @override
  String get blockTimingAfter => '之后';

  @override
  String get blockTimingReplace => '替换';

  @override
  String get blockConstValue => '返回值';

  @override
  String get blockConstValueHint => '如 true';

  @override
  String get blockConstType => '值类型';

  @override
  String get blockFieldName => '字段名';

  @override
  String get blockFieldNameHint => '如 isVip';

  @override
  String get blockFieldValue => '字段值';

  @override
  String get blockFieldValueHint => '如 true';

  @override
  String get blockIsStaticField => '静态字段';

  @override
  String get blockCustomJs => 'JavaScript 代码';

  @override
  String get blockCustomJsHint => 'Jx.log(\"hello\");';

  @override
  String get blockSelectType => '选择 Block 类型';

  @override
  String get blockHookBefore => 'Hook Before';

  @override
  String get blockHookAfter => 'Hook After';

  @override
  String get blockHookReplace => 'Hook Replace';

  @override
  String get blockBeforeConstructor => '构造前';

  @override
  String get blockAfterConstructor => '构造后';

  @override
  String get blockLog => '日志';

  @override
  String get blockLogException => '异常日志';

  @override
  String get blockConsoleLog => 'Console 日志';

  @override
  String get blockStackTrace => '调用栈';

  @override
  String get blockGetField => '读取字段';

  @override
  String get blockGetInt => '读取 Int';

  @override
  String get blockSetInt => '设置 Int';

  @override
  String get blockGetBool => '读取 Bool';

  @override
  String get blockSetBool => '设置 Bool';

  @override
  String get blockGetArg => '获取参数';

  @override
  String get blockSetArg => '修改参数';

  @override
  String get blockGetResult => '获取返回值';

  @override
  String get blockSetResult => '修改返回值';

  @override
  String get blockCallMethod => '调用方法';

  @override
  String get blockCallStatic => '调用静态方法';

  @override
  String get blockNewInstance => '创建实例';

  @override
  String get blockIf => '条件判断';

  @override
  String get blockForLoop => '循环';

  @override
  String get blockVarAssign => '变量赋值';

  @override
  String get blockToast => 'Toast 提示';

  @override
  String get blockGetApplication => '获取 Application';

  @override
  String get blockGetPackageName => '获取包名';

  @override
  String get blockGetSharedPrefs => '获取 SharedPrefs';

  @override
  String get blockGetPrefString => '读取 Pref 字符串';

  @override
  String get blockGetBuild => '获取 Build 信息';

  @override
  String get blockStartActivity => '启动 Activity';

  @override
  String get blockFindClass => '查找类';

  @override
  String get blockMessage => '消息';

  @override
  String get blockMessageHint => '日志内容';

  @override
  String get blockTag => '标签';

  @override
  String get blockTagHint => '如 Net.request';

  @override
  String get blockValue => '值';

  @override
  String get blockValueHint => '如 true';

  @override
  String get blockIndex => '索引';

  @override
  String get blockIndexHint => '如 0';

  @override
  String get blockVarName => '变量名';

  @override
  String get blockVarNameHint => '如 result';

  @override
  String get blockArgs => '参数';

  @override
  String get blockArgsHint => '逗号分隔，如 arg0, \"hello\", 123';

  @override
  String get blockCondition => '条件';

  @override
  String get blockConditionHint => '如 x > 0';

  @override
  String get blockFrom => '起始';

  @override
  String get blockFromHint => '如 0';

  @override
  String get blockTo => '结束';

  @override
  String get blockToHint => '如 10';

  @override
  String get blockConstTypeHint => '选择类型';

  @override
  String get blockPrefsName => 'Prefs 名';

  @override
  String get blockPrefsNameHint => '如 app_config';

  @override
  String get blockPrefKey => 'Key';

  @override
  String get blockPrefKeyHint => '如 token';

  @override
  String get blockSlotBody => '执行体';

  @override
  String get blockSlotBefore => '之前';

  @override
  String get blockSlotAfter => '之后';

  @override
  String get blockSlotThen => '满足条件';

  @override
  String get blockSlotElse => '否则';

  @override
  String get blockConsoleWarn => 'Console 警告';

  @override
  String get blockConsoleError => 'Console 错误';

  @override
  String get blockGetClassName => '获取类名';

  @override
  String get blockCallMethodTyped => '调用方法 (指定类型)';

  @override
  String get blockCallStaticAuto => '调用静态方法 (自动推断)';

  @override
  String get blockNewInstanceTyped => '创建实例 (指定类型)';

  @override
  String get blockGetPrefInt => '读取 Pref 整数';

  @override
  String get blockGetPrefBool => '读取 Pref 布尔';

  @override
  String get blockGetSystemProp => '获取系统属性';

  @override
  String get blockLoadClass => '加载类';

  @override
  String get blockHookAllMethods => 'Hook 所有重载';

  @override
  String get blockHookAllConstructors => 'Hook 所有构造';

  @override
  String get blockUnhook => '移除 Hook';

  @override
  String get blockGetLong => '读取 Long';

  @override
  String get blockSetLong => '设置 Long';

  @override
  String get blockGetFloat => '读取 Float';

  @override
  String get blockSetFloat => '设置 Float';

  @override
  String get blockGetDouble => '读取 Double';

  @override
  String get blockSetDouble => '设置 Double';

  @override
  String get blockGetThrowable => '获取异常';

  @override
  String get blockSetThrowable => '设置异常';

  @override
  String get blockGetMethods => '获取方法列表';

  @override
  String get blockGetFields => '获取字段列表';

  @override
  String get blockInstanceOf => '类型检查';

  @override
  String get blockSetExtra => '设置附加数据';

  @override
  String get blockGetExtra => '获取附加数据';

  @override
  String get pickVariable => '选择变量';

  @override
  String get contextVariables => '上下文变量';

  @override
  String get userVariables => '用户变量';

  @override
  String get noVariablesAvailable => '暂无可用变量';

  @override
  String get collapseAll => '全部折叠';

  @override
  String get expandAll => '全部展开';

  @override
  String get importScript => '导入';

  @override
  String get selectScriptType => '选择脚本类型';

  @override
  String get traditionalScriptDesc => '传统Hook脚本';

  @override
  String get visualScriptDesc => '可视化脚本';

  @override
  String get saveScript => '保存';

  @override
  String get exportScript => '导出';

  @override
  String get scriptSaved => '脚本已保存';

  @override
  String get scriptExported => '脚本已导出';

  @override
  String get reservedScriptFileName => '内部保留文件名，请更换文件名';

  @override
  String aiScriptSavedTo(String target, String name) {
    return '已保存到 $target: $name';
  }

  @override
  String get runScript => '运行';

  @override
  String aiScriptRunning(String target, String name) {
    return '已启用 $target 脚本: $name';
  }

  @override
  String get exportConversation => '导出会话';

  @override
  String get exportingConversation => '正在导出会话...';

  @override
  String conversationExported(String path) {
    return '会话已导出到 $path';
  }

  @override
  String exportFailed(String error) {
    return '导出失败: $error';
  }

  @override
  String get exportFormat => '导出格式';

  @override
  String get exportOptions => '导出选项';

  @override
  String get includeToolCalls => '包含工具调用';

  @override
  String get includeToolCallsDesc => '导出 AI 调用的工具和参数';

  @override
  String get includeThinking => '包含思考过程';

  @override
  String get includeThinkingDesc => '导出 AI 的推理和思考内容';

  @override
  String get preview => '预览';

  @override
  String get previewTruncated => '预览内容已截断';

  @override
  String get copyToClipboard => '复制';

  @override
  String get copiedToClipboard => '已复制到剪贴板';

  @override
  String get share => '分享';

  @override
  String get conversationExport => '会话导出';

  @override
  String get exportToFile => '保存文件';

  @override
  String aiScriptSaveFailed(String error) {
    return '保存失败: $error';
  }

  @override
  String get manifestBasicInfo => '基本信息';

  @override
  String get manifestPackage => '包名';

  @override
  String get manifestMinSdk => '最低 SDK';

  @override
  String get manifestTargetSdk => '目标 SDK';

  @override
  String get manifestDebuggable => '可调试';

  @override
  String get manifestAllowBackup => '允许备份';

  @override
  String manifestPermissions(int count) {
    return '权限 ($count)';
  }

  @override
  String get manifestNoPermissions => '无权限';

  @override
  String get manifestActivities => 'Activity';

  @override
  String get manifestServices => 'Service';

  @override
  String get manifestReceivers => 'Receiver';

  @override
  String get manifestProviders => 'Provider';

  @override
  String manifestNoItems(String name) {
    return '无 $name';
  }

  @override
  String get manifestExported => '已导出';

  @override
  String get apkNoAiSession => '未关联 AI 分析会话';

  @override
  String get apkAiAnalyze => 'AI分析';

  @override
  String apkSentToAi(String name) {
    return '已发送到 AI：分析 $name';
  }

  @override
  String apkAnalyzeSmaliPrompt(String className) {
    return '请分析 $className 的 Smali 代码，解释逻辑并给出可能的 Hook 点。';
  }

  @override
  String apkAnalyzeJavaPrompt(String className) {
    return '请分析 $className 的反编译 Java 代码，解释逻辑并给出可能的 Hook 点。';
  }

  @override
  String get undo => '撤销';

  @override
  String get redo => '重做';

  @override
  String get sendToAi => '发送给AI';

  @override
  String get pressBackAgainToExit => '再按一次返回退出';

  @override
  String apkAnalyzeSelectedCode(
    String className,
    String language,
    String code,
  ) {
    return '以下是 $className 的 $language 代码片段，请帮我分析：\n\n$code';
  }

  @override
  String get dexSearchHint => '搜索类名...';

  @override
  String dexNoClassFound(String keyword) {
    return '未找到包含 \"$keyword\" 的类';
  }

  @override
  String dexCopied(String name) {
    return '已复制: $name';
  }

  @override
  String get dexCopyShortName => '复制类名';

  @override
  String get dexCopyFullName => '复制全限定类名';

  @override
  String get soAskAi => '询问AI';

  @override
  String soSentToAi(String name) {
    return '已发送给 AI：分析 $name';
  }

  @override
  String get lsposedNotAvailable => 'LSPosed 服务不可用，请确保模块已在 LSPosed 中激活并重启应用';

  @override
  String lsposedAddingScope(String name) {
    return '正在请求添加 $name 到作用域...';
  }

  @override
  String lsposedScopeRequestedCheckNotification(String name) {
    return '已请求添加 $name 到作用域，请查看通知栏并允许';
  }

  @override
  String lsposedAddFailed(String name) {
    return '添加 $name 失败';
  }

  @override
  String get lsposedAddFailedService => '添加失败: LSPosed 服务不可用';

  @override
  String get aiMethodDetail => '方法详情';

  @override
  String get aiMethodName => '方法名';

  @override
  String get aiMethodModifier => '修饰符';

  @override
  String get aiMethodReturnType => '返回类型';

  @override
  String get aiMethodParams => '参数列表';

  @override
  String get aiMethodClass => '所属类';

  @override
  String get aiMethodHookHint => 'Hook 指引';

  @override
  String get aiMethodCopyFull => '复制完整类名.方法名';

  @override
  String get overlayMemoryToolTitle => 'Memory Tool';

  @override
  String get overlayFloatingToolWindow => '悬浮工具窗口';

  @override
  String get overlayWindowNotificationContent => '悬浮窗运行中';

  @override
  String get overlayWindowFallbackTitle => 'Overlay Window';

  @override
  String get overlayWindowUnknownSceneTitle => '悬浮场景不可用';

  @override
  String get overlayWindowUnknownSceneDescription => '当前收到的悬浮场景未注册，已阻止继续渲染。';

  @override
  String get overlayQuickWorkspace => '快速工作区';

  @override
  String get overlayQuickWorkspaceDescription => '点击悬浮气泡可以展开面板，使用右上角按钮可最小化或关闭。';

  @override
  String get overlayBubbleFeatureTitle => '悬浮气泡';

  @override
  String get overlayBubbleFeatureDescription => '单击即可展开面板。';

  @override
  String get overlayPanelFeatureTitle => '稳定面板';

  @override
  String get overlayPanelFeatureDescription => '使用普通 Material 渲染，降低显示伪影风险。';

  @override
  String get overlayConnected => '悬浮窗已连接';

  @override
  String get memoryToolTabSearch => '搜索';

  @override
  String get memoryToolTabBrowse => '浏览';

  @override
  String get memoryToolTabPointer => '指针';

  @override
  String get memoryToolTabEdit => '修改';

  @override
  String get memoryToolTabSaved => '暂存';

  @override
  String get memoryToolTabWatch => '监视';

  @override
  String get memoryToolSearchTabTitle => '搜索参数';

  @override
  String get memoryToolSearchTabSubtitle => '用于放首次搜索、范围缩小和读取入口。';

  @override
  String get memoryToolSearchModeLabel => '模式';

  @override
  String get memoryToolActionPanelTitle => '操作入口';

  @override
  String get memoryToolActionPanelSubtitle => '保留给首次扫描、继续筛选和读取操作。';

  @override
  String get memoryToolFieldValue => '数值';

  @override
  String get memoryToolFieldValuePlaceholder => '100.0';

  @override
  String get memoryToolFieldValueHint => '输入要搜索的值';

  @override
  String get memoryToolFieldType => '类型';

  @override
  String get memoryToolFieldTypePlaceholder => 'Int32';

  @override
  String get memoryToolFieldScope => '范围';

  @override
  String get memoryToolFieldScopePlaceholder => '全部内存';

  @override
  String get memoryToolFieldSearchMode => '搜索模式';

  @override
  String get memoryToolFieldFuzzyMode => '模糊条件';

  @override
  String get memoryToolFieldValueCategory => '搜索类型';

  @override
  String get memoryToolFieldValueTypeOption => '搜索格式';

  @override
  String get memoryToolFieldRangeSection => '自定义区段';

  @override
  String get memoryToolTextEncodingLabel => '文本编码';

  @override
  String get memoryToolTextEncodingUtf8 => 'UTF-8';

  @override
  String get memoryToolTextEncodingUtf16Le => 'UTF-16LE';

  @override
  String get memoryToolSearchExact => '精确搜索';

  @override
  String get memoryToolSearchFuzzy => '模糊搜索';

  @override
  String get memoryToolSearchFuzzyUnknown => '未知初值';

  @override
  String get memoryToolSearchFuzzyUnchanged => '无变化';

  @override
  String get memoryToolSearchFuzzyChanged => '有变化';

  @override
  String get memoryToolSearchFuzzyIncreased => '增加了';

  @override
  String get memoryToolSearchFuzzyDecreased => '减少了';

  @override
  String get memoryToolSearchFuzzyHint => '模糊首次扫描可不填数值，继续筛选时再输入当前值。';

  @override
  String get memoryToolSearchFuzzyUnsupportedHint => '模糊搜索目前只支持固定长度数值类型。';

  @override
  String get memoryToolSearchBytesHint => '例如 12 34 AB CD';

  @override
  String get memoryToolSearchTextHint => '输入要搜索的文本';

  @override
  String get memoryToolSearchTypePendingHint => '当前搜索类型尚未接入扫描内核。';

  @override
  String get memoryToolRangePresetPendingHint => '当前版本仍按全部可读内存扫描，范围预设暂未下发生效。';

  @override
  String get memoryToolEndianLabel => '小端序';

  @override
  String get memoryToolValueCategoryInteger => '整数';

  @override
  String get memoryToolValueCategoryDecimal => '小数';

  @override
  String get memoryToolValueCategoryBytes => '字节';

  @override
  String get memoryToolValueCategoryText => '文本';

  @override
  String get memoryToolValueCategoryGroup => '联合';

  @override
  String get memoryToolValueCategoryAdvanced => '高级';

  @override
  String get memoryToolValueTypeI8 => 'I8';

  @override
  String get memoryToolValueTypeI16 => 'I16';

  @override
  String get memoryToolValueTypeI32 => 'I32';

  @override
  String get memoryToolValueTypeI64 => 'I64';

  @override
  String get memoryToolValueTypeF32 => 'F32';

  @override
  String get memoryToolValueTypeF64 => 'F64';

  @override
  String get memoryToolValueTypeBytes => 'AOB';

  @override
  String get memoryToolValueTypeXor => 'XOR';

  @override
  String get memoryToolValueTypeAuto => 'AUTO';

  @override
  String get memoryToolValueTypeText => 'TEXT';

  @override
  String get memoryToolValueTypeGroup => '联合';

  @override
  String get memoryToolRangePresetCommon => '常用';

  @override
  String get memoryToolRangePresetJava => 'Java';

  @override
  String get memoryToolRangePresetNative => 'Native';

  @override
  String get memoryToolRangePresetCode => '代码';

  @override
  String get memoryToolRangePresetAll => '全部';

  @override
  String get memoryToolRangePresetCustom => '自定义';

  @override
  String get memoryToolRangeSectionAnonymous => '匿名';

  @override
  String get memoryToolRangeSectionJava => 'Java';

  @override
  String get memoryToolRangeSectionJavaHeap => 'Java Heap';

  @override
  String get memoryToolRangeSectionCAlloc => 'C Alloc';

  @override
  String get memoryToolRangeSectionCHeap => 'C Heap';

  @override
  String get memoryToolRangeSectionCData => 'C Data';

  @override
  String get memoryToolRangeSectionCBss => 'C Bss';

  @override
  String get memoryToolRangeSectionCodeApp => '应用代码';

  @override
  String get memoryToolRangeSectionCodeSys => '系统代码';

  @override
  String get memoryToolRangeSectionStack => '栈';

  @override
  String get memoryToolRangeSectionAshmem => 'Ashmem';

  @override
  String get memoryToolRangeSectionOther => '其他';

  @override
  String get memoryToolRangeSectionBad => 'Bad';

  @override
  String get memoryToolActionFirstScan => '首次扫描';

  @override
  String get memoryToolActionNextScan => '继续筛选';

  @override
  String get memoryToolActionRead => '读取';

  @override
  String get memoryToolActionReset => '重置会话';

  @override
  String get memoryToolEditTabTitle => '修改工作区';

  @override
  String get memoryToolEditTabSubtitle => '这里适合放指定地址写入、批量修改和冻结入口。';

  @override
  String get memoryToolEditActionWriteValue => '向目标地址写入新数值';

  @override
  String get memoryToolEditActionFreezeValue => '把结果加入冻结列表并保持值不变';

  @override
  String get memoryToolEditActionBatchWrite => '对筛选结果执行批量写入';

  @override
  String get memoryToolPatchTabTitle => '补丁与脚本';

  @override
  String get memoryToolPatchTabSubtitle => '适合放 Hex 补丁、汇编修改和恢复原值。';

  @override
  String get memoryToolPatchActionHex => 'Hex Patch 编辑入口';

  @override
  String get memoryToolPatchActionAsm => '汇编修改入口';

  @override
  String get memoryToolPatchActionRestore => '恢复原始值与补丁';

  @override
  String get memoryToolWatchTabTitle => '监视列表';

  @override
  String get memoryToolWatchTabSubtitle => '这里适合展示常驻监视值和冻结状态。';

  @override
  String get memoryToolSessionTitle => '搜索会话';

  @override
  String get memoryToolSessionEmpty => '当前还没有活动会话，先执行一次首次扫描。';

  @override
  String get memoryToolSessionMismatch => '当前会话不属于这个进程，请重新执行首次扫描。';

  @override
  String get memoryToolSessionPid => '会话 PID';

  @override
  String get memoryToolSessionRegionCount => '区段数';

  @override
  String get memoryToolSessionResultCount => '结果数';

  @override
  String get memoryToolSessionSelectedCount => '选中数';

  @override
  String get memoryToolSessionPageCount => '分页数';

  @override
  String get memoryToolSessionRenderedCount => '当前渲染';

  @override
  String get memoryToolSessionBoundToCurrent => '已绑定当前进程';

  @override
  String get memoryToolTaskFirstScanTitle => '首次扫描进行中';

  @override
  String get memoryToolTaskNextScanTitle => '继续筛选进行中';

  @override
  String get memoryToolTaskRunningHint => '正在读取目标进程内存，期间可以取消扫描。';

  @override
  String get memoryToolTaskElapsedLabel => '耗时';

  @override
  String get memoryToolTaskRegionsLabel => '区段';

  @override
  String get memoryToolTaskEntriesLabel => '候选';

  @override
  String get memoryToolTaskBytesLabel => '字节';

  @override
  String get memoryToolTaskResultCountLabel => '命中';

  @override
  String get memoryToolTaskCancelAction => '取消扫描';

  @override
  String get memoryToolTaskCancelled => '扫描已取消。';

  @override
  String get memoryToolTaskFailedFallback => '扫描失败，请重试。';

  @override
  String get memoryToolResultTitle => '命中结果';

  @override
  String get memoryToolResultEmpty => '当前没有命中结果。';

  @override
  String get memoryToolResultInactiveHint => '执行首次扫描后，这里会显示命中地址。';

  @override
  String get memoryToolResultAddress => '地址';

  @override
  String get memoryToolResultRegion => '区段';

  @override
  String get memoryToolResultType => '类型';

  @override
  String get memoryToolResultValue => '值';

  @override
  String get memoryToolResultPreviousValue => '上次值';

  @override
  String get memoryToolFrozenBadge => '冻结';

  @override
  String get memoryToolResultDetailTitle => '结果详情';

  @override
  String get memoryToolResultDetailActionsLabel => '快捷操作';

  @override
  String get memoryToolResultDetailActionEdit => '编辑';

  @override
  String get memoryToolResultDetailActionWatch => '加入监视';

  @override
  String get memoryToolResultDetailActionCopyAddress => '复制地址';

  @override
  String get memoryToolResultDetailActionCopyValue => '复制数值';

  @override
  String get memoryToolResultActionPointerScan => '指针搜索';

  @override
  String get memoryToolResultActionAutoChaseStatic => '一键寻址';

  @override
  String get memoryToolResultActionJumpToPointer => '跳转到指针';

  @override
  String get memoryToolResultActionPreviewMemoryBlock => '预览内存块';

  @override
  String get memoryToolResultActionOffsetPreview => '偏移量计算';

  @override
  String get memoryToolJumpAddressTitle => '地址跳转';

  @override
  String get memoryToolJumpAddressFieldLabel => '目标地址';

  @override
  String get memoryToolJumpAddressAction => '跳转到目标地址';

  @override
  String get memoryToolJumpAddressInvalid => '地址格式无效';

  @override
  String get memoryToolResultActionCopyHex => '复制十六进制';

  @override
  String get memoryToolResultActionCopyReverseHex => '复制反十六进制';

  @override
  String get memoryToolPointerScanTitle => '指针搜索';

  @override
  String get memoryToolPointerAutoChaseTitle => '一键寻址';

  @override
  String get memoryToolPointerTargetAddressLabel => '目标地址';

  @override
  String get memoryToolPointerWidthLabel => '指针宽度';

  @override
  String get memoryToolPointerMaxOffsetLabel => '最大偏移';

  @override
  String get memoryToolPointerMaxDepthLabel => '指针层数';

  @override
  String get memoryToolPointerAlignmentLabel => '对齐步长';

  @override
  String get memoryToolPointerAlignmentPointerWidth => '按指针宽度';

  @override
  String get memoryToolPointerInvalidMaxOffset => '请输入有效偏移量';

  @override
  String get memoryToolPointerInvalidMaxDepth => '请输入 1 到 12 的层数';

  @override
  String get memoryToolPointerActionContinueSearch => '继续搜索上一层指针';

  @override
  String get memoryToolPointerActionJumpToTarget => '跳转到指针目标';

  @override
  String get memoryToolPointerActionCopyPointerAddress => '复制指针地址';

  @override
  String get memoryToolPointerActionCopyPointedAddress => '复制指向地址';

  @override
  String get memoryToolPointerActionCopyTargetAddress => '复制目标地址';

  @override
  String get memoryToolPointerActionCopyExpression => '复制表达式';

  @override
  String get memoryToolPointerOffsetLabel => '偏移';

  @override
  String get memoryToolPointerBaseAddressLabel => '基址';

  @override
  String get memoryToolPointerPointerAddressLabel => '指针地址';

  @override
  String get memoryToolPointerBadgeAuto => '推荐';

  @override
  String get memoryToolPointerBadgeStatic => '静态区';

  @override
  String get memoryToolPointerEmpty => '从搜索、浏览或暂存结果长按并选择指针搜索';

  @override
  String memoryToolPointerLoadedCount(int loaded, int total) {
    return '已加载 $loaded / 总计 $total';
  }

  @override
  String get memoryToolPointerTaskRunningTitle => '指针搜索进行中';

  @override
  String get memoryToolPointerStopReasonStaticReached => '已命中静态区';

  @override
  String get memoryToolPointerStopReasonNoMorePointers => '无更多上层指针';

  @override
  String get memoryToolPointerStopReasonMaxDepth => '已达指针层数';

  @override
  String get memoryToolPointerStopReasonCancelled => '已取消';

  @override
  String get memoryToolPointerStopReasonFailed => '扫描失败';

  @override
  String get memoryToolOffsetPreviewTitle => '偏移量计算';

  @override
  String get memoryToolOffsetPreviewOffsetLabel => '偏移量';

  @override
  String get memoryToolOffsetPreviewHexLabel => 'HEX';

  @override
  String get memoryToolOffsetPreviewTargetAddress => '目标地址';

  @override
  String get memoryToolOffsetPreviewTargetValue => '目标数值';

  @override
  String get memoryToolOffsetPreviewInvalid => '请输入有效偏移量';

  @override
  String get memoryToolOffsetPreviewUnreadable => '当前地址不可读';

  @override
  String get memoryToolBrowseEmpty => '从搜索结果长按并选择预览内存块';

  @override
  String get memoryToolResultActionTitle => '更多操作';

  @override
  String get memoryToolResultActionSelectCurrent => '选中当前项';

  @override
  String get memoryToolResultActionSelectCurrentHint => '把当前结果加入选择集，便于后续统一处理。';

  @override
  String get memoryToolResultActionStartMultiSelect => '进入多选模式';

  @override
  String get memoryToolResultActionStartMultiSelectHint => '从当前结果开始进行多选和批量操作。';

  @override
  String get memoryToolResultActionBatchEdit => '批量修改';

  @override
  String get memoryToolResultActionBatchEditHint => '为后续批量写入和筛选后的编辑预留入口。';

  @override
  String get memoryToolBatchEditIncrementUnsupported => '递增模式仅支持数值类型';

  @override
  String get memoryToolBatchEditNoReadableResults => '没有可读取的选中结果。';

  @override
  String get memoryToolBatchEditIncrementLabel => '递增';

  @override
  String get memoryToolBatchEditStepLabel => '步长';

  @override
  String get memoryToolBatchEditPreviewLabel => '预览';

  @override
  String get memoryToolResultActionSaveToSaved => '保存到暂存区';

  @override
  String get memoryToolResultActionSaveToSavedHint => '把当前结果加入暂存区，便于后续集中编辑与冻结。';

  @override
  String memoryToolSavedToSavedMessage(Object count) {
    return '已保存 $count 项到暂存区';
  }

  @override
  String get memoryToolDebugAccessRead => '读';

  @override
  String get memoryToolDebugAccessWrite => '写';

  @override
  String get memoryToolDebugAccessReadWrite => '读写';

  @override
  String get memoryToolDebugBreakpointsTitle => '断点列表';

  @override
  String get memoryToolDebugBreakpointsTab => '断点';

  @override
  String get memoryToolDebugWritersTitle => '写入源';

  @override
  String get memoryToolDebugDetailTitle => '详情';

  @override
  String get memoryToolDebugEmptyBreakpoints => '还没有断点';

  @override
  String get memoryToolDebugEnabled => '已启用';

  @override
  String get memoryToolDebugDisabled => '已禁用';

  @override
  String get memoryToolDebugPauseOnHit => '命中即暂停';

  @override
  String get memoryToolDebugRecordOnly => '仅记录';

  @override
  String get memoryToolDebugHitCountUnit => '次命中';

  @override
  String get memoryToolDebugLastHitPrefix => '最近命中';

  @override
  String get memoryToolDebugEmptyWriters => '这个断点还没有命中';

  @override
  String get memoryToolDebugThreadCountUnit => '线程';

  @override
  String get memoryToolDebugEmptyDetail => '选择一个写入源查看详情';

  @override
  String get memoryToolDebugCurrentValue => '当前值';

  @override
  String get memoryToolDebugNoHitYet => '暂无命中';

  @override
  String get memoryToolDebugBreakpointAddress => '断点地址';

  @override
  String get memoryToolDebugPointer => '指针';

  @override
  String get memoryToolDebugAnonymousModule => '[匿名模块]';

  @override
  String get memoryToolDebugModuleOffset => '模块偏移';

  @override
  String get memoryToolDebugInstruction => '指令';

  @override
  String get memoryToolDebugCommonRewrite => '常见改写';

  @override
  String get memoryToolDebugRecentHits => '最近命中';

  @override
  String get memoryToolDebugStatBreakpoints => '断点';

  @override
  String get memoryToolDebugStatActive => '活动';

  @override
  String get memoryToolDebugStatWriters => '写入源';

  @override
  String get memoryToolDebugStatCurrentHits => '当前命中';

  @override
  String get memoryToolDebugStatPending => '待处理';

  @override
  String get memoryToolDebugStatLength => '长度';

  @override
  String get memoryToolDebugSelectProcessFirst => '请先选择进程';

  @override
  String get memoryToolDebugSelectProcessHint =>
      '长按搜索结果、预览结果或暂存结果创建断点后，这里会显示命中记录和写入指令。';

  @override
  String get memoryToolDebugActionCopyValue => '复制值';

  @override
  String get memoryToolDebugActionCopyHex => '复制 Hex';

  @override
  String get memoryToolDebugActionCopyReverseHex => '复制反序 Hex';

  @override
  String get memoryToolDebugActionBrowseAddress => '浏览地址';

  @override
  String get memoryToolDebugActionPointerScan => '指针扫描';

  @override
  String get memoryToolDebugActionAutoChase => '自动追踪';

  @override
  String get memoryToolDebugActionCopyAddress => '复制地址';

  @override
  String get memoryToolDebugActionBrowseHitPointer => '浏览该命中指针';

  @override
  String get memoryToolDebugActionCopyModuleOffset => '复制模块偏移';

  @override
  String get memoryToolDebugActionCopyInstruction => '复制指令';

  @override
  String get memoryToolDebugActionCopyRewrite => '复制改写文本';

  @override
  String get memoryToolResultActionAddWatch => '加入监视列表';

  @override
  String get memoryToolResultActionAddWatchHint => '把当前结果加入监视区，后续持续查看变化。';

  @override
  String get memoryToolResultActionFreeze => '加入冻结队列';

  @override
  String get memoryToolResultActionFreezeHint => '为后续冻结和保持数值稳定预留入口。';

  @override
  String get memoryToolSavedEmpty => '暂无暂存数据';

  @override
  String get memoryToolResultCalculatorTitle => '偏移 / 异或';

  @override
  String memoryToolResultCalculatorSummary(
    Object selectedCount,
    Object pairCount,
  ) {
    return '已选 $selectedCount 项，可计算 $pairCount 组';
  }

  @override
  String get memoryToolResultCalculatorNeedAtLeastTwo => '至少选择 2 个整数结果。';

  @override
  String get memoryToolResultCalculatorValues => '值';

  @override
  String get memoryToolResultCalculatorCombinations => '组合';

  @override
  String get memoryToolResultCalculatorOffset => '偏移';

  @override
  String get memoryToolResultCalculatorXor => '异或';

  @override
  String get memoryToolAssemblyPreviewTitle => '汇编预览';

  @override
  String memoryToolAssemblyPreviewCount(int count) {
    return '$count 个地址';
  }

  @override
  String get memoryToolAssemblyPreviewEmpty => '没有可渲染的汇编';

  @override
  String get memoryToolResultSelectionDialogTitle => '结果列表设置';

  @override
  String get memoryToolResultSelectionSearchDescription =>
      '控制搜索页当前渲染数量，同时也是多选、保存、批量修改等操作的上限。';

  @override
  String get memoryToolResultSelectionBrowseDescription =>
      '控制浏览页单次可选数量和分页统计，不会清空已经加载的内存结果。';

  @override
  String get memoryToolResultSelectionFieldLabel => '数量上限';

  @override
  String get memoryToolResultSelectionHelperText =>
      '建议 50 - 200，数值越大，列表渲染和批量操作越重。';

  @override
  String get memoryToolResultSelectionPresetLabel => '快速选择';

  @override
  String get memoryToolResultSelectionUnit => '项';

  @override
  String get memoryToolResultSelectionRequired => '请输入大于 0 的整数';

  @override
  String get memoryToolResultSelectionInvalid => '请输入大于 0 的整数';

  @override
  String memoryToolResultSelectionCurrent(int count) {
    return '当前值：$count 项';
  }

  @override
  String get memoryToolTargetProcess => '目标进程';

  @override
  String get memoryToolValidationValueRequired => '请先输入搜索值。';

  @override
  String get memoryToolValidationBytesInvalid =>
      '字节数组格式不正确，请输入偶数位十六进制，例如 12 34 AB。';

  @override
  String get memoryToolValidationIntegerInvalid => '整数类型只能输入整数值。';

  @override
  String get memoryToolValidationIntegerOutOfRange => '整数值超出当前类型可搜索的范围。';

  @override
  String get memoryToolValidationDecimalInvalid => '小数类型请输入有效的数字。';

  @override
  String get memoryToolValidationGroupInvalid =>
      '联合搜索格式错误，例：i32:100;i32:200::32';

  @override
  String get memoryToolValidationGroupMissingWindow =>
      '联合搜索缺少 ::window，例：i32:100;i32:200::32';

  @override
  String get memoryToolValidationGroupInvalidWindow =>
      '联合搜索 window 必须是大于 0 的整数。';

  @override
  String get memoryToolValidationGroupWindowTooLarge =>
      '联合搜索 window 最大支持 4096 字节。';

  @override
  String get memoryToolValidationGroupTooFewConditions => '联合搜索至少需要两个条件。';

  @override
  String get memoryToolValidationTypeUnsupported => '当前搜索类型尚未接入扫描内核。';

  @override
  String get memoryToolProcessTerminatedTitle => '目标进程已退出';

  @override
  String get memoryToolProcessTerminatedDescription =>
      '当前选中的目标进程已经关闭，搜索会话和选择状态已被终止。请重新选择进程后再继续操作。';

  @override
  String get memoryToolProcessTerminatedAction => '我知道了';

  @override
  String get create => '创建';

  @override
  String get createScript => '创建脚本';

  @override
  String get scriptName => '脚本名称';

  @override
  String get newScript => '新脚本';

  @override
  String get createSuccess => '创建成功';

  @override
  String get createFailed => '创建失败';

  @override
  String get importSuccess => '导入成功';

  @override
  String get importFailed => '导入失败';

  @override
  String get shareSuccess => '分享成功';

  @override
  String get shareFailed => '分享失败';

  @override
  String get deleteScriptHint => '确认删除此脚本？';

  @override
  String get deleteSuccess => '删除成功';

  @override
  String get deleteFailed => '删除失败';
}
