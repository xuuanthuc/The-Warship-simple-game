import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../routes/navigation_service.dart';
import '../../style/app_colors.dart';
import '../../style/app_images.dart';

class PrimaryDialog extends StatefulWidget {
  final String title;
  final List<Widget> children;

  const PrimaryDialog({
    super.key,
    required this.children,
    required this.title,
  });

  @override
  State<PrimaryDialog> createState() => _PrimaryDialogState();
}

class _PrimaryDialogState extends State<PrimaryDialog>
    with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: SingleChildScrollView(
        child: Container(
          width: MediaQuery.sizeOf(context).width * 0.3,
          constraints: const BoxConstraints(minWidth: 700),
          decoration: BoxDecoration(
            color: AppColors.gray,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              width: 2,
              color: Colors.white,
            ),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: Opacity(
                  opacity: 0.3,
                  child: ScaleTransition(
                    scale:
                        Tween<double>(begin: 1, end: 1.05).animate(_controller),
                    child: Image.asset(
                      AppImages.lobby,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.grayDark,
                      border: Border(
                        bottom: BorderSide(
                          width: 4.h,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                    padding: EdgeInsets.all(8.h),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              widget.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: "Mitr",
                                fontWeight: FontWeight.w600,
                                fontSize: 22.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () => navService.pop(),
                              icon: SizedBox(
                                width: 40.w,
                                height: 40.h,
                                child: Image.asset(AppImages.close),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.h),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [...widget.children],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
