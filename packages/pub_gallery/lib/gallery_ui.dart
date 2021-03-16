part of pub_gallery;

class GalleryUI extends StatelessWidget {
  final GalleryController _galleryController = Get.put(GalleryController());
  final String groupName;
  final double initHeightZeroToOne;
  final double minHeightZeroToOne;

  final ValueChanged<List<AssetEntity>> imagesChoice;
  final ValueChanged<bool> backButton;

  GalleryUI(
      {this.groupName,
      this.initHeightZeroToOne,
      this.minHeightZeroToOne,
      this.imagesChoice, this.backButton});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => SafeArea(
            child: Stack(
              children: [
                Positioned.fill(
                  bottom: 0,
                  child: (_galleryController.isShowGallery.value)
                      ? NotificationListener<DraggableScrollableNotification>(
                          onNotification: (notification) {
                            _galleryController.extent.value =
                                notification.extent;
                            return true;
                          },
                          child: DraggableScrollableSheet(
                            initialChildSize: initHeightZeroToOne ?? 0.5,
                            minChildSize: minHeightZeroToOne ?? 0,
                            maxChildSize: 0.92,
                            builder: (context, controller) {
                              return Material(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)),
                                color: Colors.white,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
                                  child: Obx(() => (_galleryController
                                          .isLoading.value)
                                      ? GridView.builder(
                                          controller: controller,
                                          itemCount: _galleryController
                                              .listFolder[0].assetCount,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3,
                                            mainAxisSpacing: 5,
                                            crossAxisSpacing: 5,
                                          ),
                                          itemBuilder: _buildImage)
                                      : loadWidget(20)),
                                ),
                              );
                            },
                          ))
                      : SizedBox.shrink(),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  height: (_galleryController.extent.value == 0.92)
                      ? Get.height * 0.08
                      : 0,
                  child: Material(
                    child: Row(
                      children: [
                        BackButton(
                          onPressed: (){
                            backButton(true);
                          },
                        ),
                        Text(
                          'Pick Gallery',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    bottom: 20,
                    right: 10,
                    child: Obx(() {
                      if (_galleryController.imageChoiceList.length > 0)
                        return Stack(
                          children: [
                            GestureDetector(
                              onTap: () {
                                imagesChoice(
                                    _galleryController.imageChoiceList);
                              },
                              child: Container(
                                height: 60,
                                width: 60,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle, color: Colors.blue),
                                child: Center(
                                  child: Icon(
                                    Icons.send_outlined,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.blue,
                                      border: Border.all(
                                          color: Colors.white, width: 3)),
                                  child: Center(
                                    child: Text(
                                      '${_galleryController.imageChoiceList.length}',
                                      style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ))
                          ],
                        );
                      else
                        return SizedBox.shrink();
                    }))
              ],
            ),
          )),
    );
  }

  Widget _buildImage(BuildContext context, int index) {
    if (_galleryController.imageList.length - 6 == index)
      _galleryController.loadMoreItem();

    if (index > _galleryController.imageList.length - 1) {
      return loadWidget(10);
    }

    final ImageModel imageModel = _galleryController.imageList[index];

    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            _galleryController.currentIndex.value = index;
            Get.to(() => ImageDetail(
                  imageList: _galleryController.imageList,
                  initIndex: index,
                  groupName: groupName,
                  imagesChoice: imagesChoice,
                ));
          },
          child: ImageItem(
            imageModel: imageModel,
          ),
        ),
        Positioned(
            top: 5,
            right: 5,
            child: Obx(() => GestureDetector(
                  onTap: () {
                    _galleryController
                        .actionImageChoiceList(imageModel.assetEntity);
                  },
                  child: (_galleryController
                          .checkImageChoice(imageModel.assetEntity))
                      ? Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle, color: Colors.blue),
                          child: Center(
                            child: Text(
                              '${_galleryController.getIndexImageChoice(imageModel.assetEntity)}',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                      : Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              color: Colors.transparent),
                        ),
                )))
      ],
    );
  }
}
