part of 'widgets.dart';

class CustomDrawerSettingWidget extends StatefulWidget {
  const CustomDrawerSettingWidget({super.key});

  @override
  State<CustomDrawerSettingWidget> createState() =>
      _CustomDrawerSettingWidgetState();
}

class _CustomDrawerSettingWidgetState extends State<CustomDrawerSettingWidget> {
  final ThemeController _themeController = Get.find();
  final MainController _mainController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        decoration: BoxDecoration(
          boxShadow: [
            SharedMethod.renderBoxShadow(
                dx: -2, blurRadius: 5, opacity: .07, color: Colors.black),
          ],
        ),
        child: Drawer(
          backgroundColor: _themeController.getBlendColor(context),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
          child: Theme(
            data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                renderHeaderDrawer(),
                const SizedBox(height: 10),
                Divider(
                    color: _themeController.getPrimaryTextColor.value
                        .withOpacity(.2)),
                Expanded(child: renderBodyDrawer()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget renderHeaderDrawer() {
    return const SafeArea(
      child: PaddingColumn(
        crossAxisAlignment: CrossAxisAlignment.start,
        padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
        children: [
          Text('THEME CUSTOMIZER',
              style: TextStyle(fontWeight: FontWeight.w500)),
          Text('Customize & Preview in Real Time',
              style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget renderBodyDrawer() {
    return ListView(
      padding: const EdgeInsets.only(bottom: 50),
      children: [
        PaddingColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          children: [
            Text('THEMING',
                style: TextStyle(
                    fontSize: 12,
                    color: _themeController.getSecondaryTextColor.value,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            renderSettingCard(
              CustomDrawerItemSetting(
                title: 'Mode',
                subtitle:
                    "By turning on the dark theme you can save your phone's battery",
                note:
                    "Activating this feature is not recommended if you have limitations in vision.",
                child: Row(
                  children: [
                    Expanded(
                      child: renderRadioBoolean(
                        label: 'Dark',
                        value: true,
                        onTap: () => _themeController.setThemeMode(true),
                        groupValue: _themeController.isDarkMode.value,
                      ),
                    ),
                    Expanded(
                      child: renderRadioBoolean(
                        label: 'Light',
                        value: false,
                        onTap: () => _themeController.setThemeMode(false),
                        groupValue: _themeController.isDarkMode.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            renderSettingCard(
              CustomDrawerItemSetting(
                title: 'Primary Color',
                subtitle:
                    "Theme colors show the color values defined for the selected color scheme.",
                child: MasonryGridView.count(
                  itemCount: _themeController.themeDataList.length,
                  shrinkWrap: true,
                  crossAxisCount: 4,
                  mainAxisSpacing: 30,
                  crossAxisSpacing: 8,
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) =>
                      Obx(() => renderThemeCard(index)),
                ),
              ),
            ),
            const SizedBox(height: 30),
            renderSettingCard(
              CustomDrawerItemSetting(
                title: 'Border Radius',
                subtitle: "Border radius items in the application",
                note:
                    "changing the value above will change the border radius throughout the application.",
                child: SizedBox(
                  height: 25,
                  child: Slider(
                    max: 100,
                    divisions: 100,
                    activeColor: _themeController.primaryColor200.value,
                    value: _themeController.borderRadius.value,
                    label: '${_themeController.borderRadius.value.round()}%',
                    onChanged: (double value) async =>
                        _themeController.setThemeBorderRadius(value),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(
            color: _themeController.getPrimaryTextColor.value.withOpacity(.2)),
        const SizedBox(height: 15),
        PaddingColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          children: [
            Text('LAYOUT',
                style: TextStyle(
                    fontSize: 12,
                    color: _themeController.getSecondaryTextColor.value,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            renderSettingCard(
              CustomDrawerItemSetting(
                title: 'Position Message',
                subtitle: "Floating message position in the application",
                note:
                    "Changing the value below will change the position of the floating message in all applications.",
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: renderRadioBoolean(
                            label: 'Top',
                            value: true,
                            onTap: () =>
                                _themeController.setSnackPosition(true),
                            groupValue: _themeController.snackPosition.value ==
                                SnackPosition.TOP,
                          ),
                        ),
                        Expanded(
                          child: renderRadioBoolean(
                            label: 'Bottom',
                            value: false,
                            onTap: () =>
                                _themeController.setSnackPosition(false),
                            groupValue: _themeController.snackPosition.value ==
                                SnackPosition.TOP,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomButton(
                      height: 30,
                      padding: EdgeInsets.zero,
                      label: 'Try Message...',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: _themeController.primaryColor200.value),
                      color: _themeController.primaryColor200.value
                          .withOpacity(.2),
                      borderRadius: BorderRadius.circular(
                          _themeController.getThemeBorderRadius(7)),
                      onTap: () {
                        _mainController.globalScaffoldKey.currentState
                            ?.closeEndDrawer();
                        SharedWidget.renderDefaultSnackBar(
                            message: 'This is a debug message');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Divider(
            color: _themeController.getPrimaryTextColor.value.withOpacity(.2)),
        const SizedBox(height: 15),
        PaddingColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
          children: [
            Text('MISC',
                style: TextStyle(
                    fontSize: 12,
                    color: _themeController.getSecondaryTextColor.value,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            renderSettingCard(
              CustomDrawerItemSetting(
                title: 'Record History Logs',
                subtitle:
                    "ON to activate the logs feature, OFF to turn off the logs feature.",
                note:
                    'This feature is used to find out the history of download/upload data',
                child: Row(
                  children: [
                    Expanded(
                      child: renderRadioBoolean(
                        label: 'ON',
                        value: true,
                        onTap: () => _themeController.setHistoryLog(true),
                        groupValue: _themeController.historyLog.value,
                      ),
                    ),
                    Expanded(
                      child: renderRadioBoolean(
                        label: 'OFF',
                        value: false,
                        onTap: () => _themeController.setHistoryLog(false),
                        groupValue: _themeController.historyLog.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            renderSettingCard(
              CustomDrawerItemSetting(
                title: 'Debug Mode',
                subtitle:
                    "Operating modes on the software that the developer allows",
                note: 'This mode is only for developers',
                child: Row(
                  children: [
                    Expanded(
                      child: renderRadioBoolean(
                        label: 'ON',
                        value: true,
                        onTap: () {
                          _mainController.globalScaffoldKey.currentState
                              ?.closeEndDrawer();
                          _themeController.setDebugMode(true).then((_) {
                            if (_themeController.debugMode.value) {
                              _mainController.globalScaffoldKey.currentState
                                  ?.openEndDrawer();
                            }
                          });
                        },
                        groupValue: _themeController.debugMode.value,
                      ),
                    ),
                    Expanded(
                      child: renderRadioBoolean(
                        label: 'OFF',
                        value: false,
                        onTap: () => _themeController.setDebugMode(false),
                        groupValue: _themeController.debugMode.value,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
                visible: _themeController.debugMode.value,
                child: const SizedBox(height: 30)),
            Visibility(
              visible: _themeController.debugMode.value,
              child: renderSettingCard(
                CustomDrawerItemSetting(
                  title: 'Show Log Button (Debug Mode)',
                  subtitle: "ON to display the logs button",
                  note: 'This feature is only for developers',
                  isDeprecated: true,
                  child: Row(
                    children: [
                      Expanded(
                        child: renderRadioBoolean(
                          label: 'ON',
                          value: true,
                          onTap: () => _themeController.setShowButtonLog(true),
                          groupValue: _themeController.showButtonLog.value,
                        ),
                      ),
                      Expanded(
                        child: renderRadioBoolean(
                          label: 'OFF',
                          value: false,
                          onTap: () => _themeController.setShowButtonLog(false),
                          groupValue: _themeController.showButtonLog.value,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
                visible: _themeController.debugMode.value &&
                    _themeController.isMobile,
                child: const SizedBox(height: 30)),
            Visibility(
              visible:
                  _themeController.debugMode.value && _themeController.isMobile,
              child: renderSettingCard(
                CustomDrawerItemSetting(
                  title: 'History Log (Debug Mode)',
                  subtitle: "View all logs that have been recorded",
                  note:
                      'This feature is only for developers and available only for mobile devices',
                  child: CustomButton(
                    height: 30,
                    padding: EdgeInsets.zero,
                    label: 'Settings Service...',
                    enable: _themeController.debugMode.value,
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: _themeController.primaryColor200.value),
                    color:
                        _themeController.primaryColor200.value.withOpacity(.2),
                    borderRadius: BorderRadius.circular(
                        _themeController.getThemeBorderRadius(7)),
                    onTap: () {
                      _mainController.globalScaffoldKey.currentState
                          ?.closeEndDrawer();
                      Get.toNamed(Routes.logs);
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget renderThemeCard(int index) {
    CustomDataTheme data = _themeController.themeDataList[index];

    Widget child = index == _themeController.selectedTheme.value
        ? AnimatedContainer(
            width: 45,
            height: 45,
            duration: const Duration(milliseconds: 300),
            decoration: BoxDecoration(
              color: _themeController.getPrimaryTextColor.value.withOpacity(.1),
              borderRadius: BorderRadius.circular(
                  _themeController.getThemeBorderRadius(5)),
            ),
            child: const Icon(EvaIcons.checkmarkCircle,
                color: Colors.white, size: 21))
        : const SizedBox();

    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () => _themeController.setTheme(index),
      child: AnimatedContainer(
        width: 45,
        height: 45,
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: data.primaryColor200,
          borderRadius:
              BorderRadius.circular(_themeController.getThemeBorderRadius(5)),
        ),
        child: child,
      ),
    );
  }

  Widget renderRadioBoolean({
    required String label,
    required bool value,
    required bool groupValue,
    GestureTapCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      child: Row(
        children: [
          SizedBox(
            height: 20,
            child: Transform.scale(
              scale: .8,
              child: Radio<bool>(
                value: value,
                groupValue: groupValue,
                fillColor: _themeController.getMaterialStateColor,
                onChanged: (value) => onTap != null ? onTap() : () {},
              ),
            ),
          ),
          Expanded(
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget renderSettingCard(CustomDrawerItemSetting data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Visibility(
          visible: data.isDeprecated,
          child: Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
            decoration: BoxDecoration(
                color: Colors.red.withOpacity(.2),
                borderRadius: BorderRadius.circular(
                    _themeController.getThemeBorderRadius(6))),
            child: const Text(
              'Deprecated',
              style: TextStyle(
                  fontSize: 8, color: Colors.red, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data.title,
                      maxLines: 1,
                      style: const TextStyle(fontWeight: FontWeight.w500)),
                  Text(data.subtitle,
                      style: TextStyle(
                          fontSize: 12,
                          color: _themeController.getSecondaryTextColor.value)),
                ],
              ),
            ),
            if (data.icon != null)
              CircleAvatar(
                  radius: 15,
                  backgroundColor: SharedValue.textLightColor200,
                  child: Icon(data.icon))
          ],
        ),
        const SizedBox(height: 12),
        data.child,
        if (data.note != null) const SizedBox(height: 12),
        if (data.note != null)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('*Note:', style: TextStyle(fontSize: 12)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(data.note ?? '',
                    style: TextStyle(
                        fontSize: 12,
                        color: _themeController.getSecondaryTextColor.value)),
              ),
            ],
          ),
      ],
    );
  }
}
