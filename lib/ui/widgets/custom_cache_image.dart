part of 'widgets.dart';

class CustomCacheImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width, height;
  final ProgressIndicatorBuilder? progressIndicatorBuilder;

  const CustomCacheImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.progressIndicatorBuilder,
  });

  @override
  State<CustomCacheImage> createState() => _CustomCacheImageState();
}

class _CustomCacheImageState extends State<CustomCacheImage> {
  final ThemeController _themeController = Get.find();

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
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      fit: widget.fit,
      width: widget.width,
      height: widget.height,
      progressIndicatorBuilder: widget.progressIndicatorBuilder ??
          (context, url, downloadProgress) => Center(
                child: SizedBox(
                  width: 20,
                  child: LoadingIndicator(
                    indicatorType: Indicator.ballPulseSync,
                    colors: [_themeController.primaryColor200.value],
                  ),
                ),
              ),
    );
  }
}
