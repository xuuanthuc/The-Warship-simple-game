// import 'dart:io';
//
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// abstract class RequestPermission {
//   static Future<bool?> canAccessImagePicker(ImageSource imageSource) async {
//     if (imageSource == ImageSource.camera) {
//       var cameraStatus = await Permission.camera.request();
//       if (cameraStatus.isGranted) {
//         return true;
//       } else {
//         var status = await Permission.camera.status;
//         if (cameraStatus.isPermanentlyDenied && status.isDenied) {
//           return false;
//         } else if (cameraStatus.isGranted) {
//           return true;
//         } else if (cameraStatus.isPermanentlyDenied &&
//             status.isPermanentlyDenied) {
//           if (Platform.isIOS) {
//             return false;
//           }
//         } else {
//           return null;
//         }
//       }
//     } else if (imageSource == ImageSource.gallery) {
//       if (Platform.isIOS) {
//         var photosStatus = await Permission.photos.request();
//         if (photosStatus.isPermanentlyDenied) {
//           return false;
//         } else if (photosStatus.isGranted || photosStatus.isLimited) {
//           return true;
//         } else {
//           return null;
//         }
//       }
//       return true;
//     }
//     return false;
//   }
// }
