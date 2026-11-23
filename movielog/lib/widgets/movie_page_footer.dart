import 'package:flutter/widgets.dart';
import 'package:movielog/view_models/load_phase.dart';
import 'package:movielog/view_models/page_movies_view_model.dart';
import 'package:movielog/widgets/movielog_button.dart';

class MoviePageFooter extends StatelessWidget {
  const MoviePageFooter({
    super.key,
    required this.vm,
    this.loadMoreLabel = '더 보기',
    this.padding = const EdgeInsets.all(16),
  });

  final PagedMoviesViewModel vm;
  final String loadMoreLabel;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    if (!vm.hasMore && !vm.isLoadingMore && vm.loadMoreError == null) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('더 이상 조회할 페이지가 없습니다.', textAlign: TextAlign.center),
      );
    }

    return Padding(
      padding: padding,
      child: Column(
        children: [
          if (vm.loadMoreError != null) Text(vm.loadMoreError!),
          MovieLogButton(
            width: double.infinity,
            label: vm.loadMoreError == null ? loadMoreLabel : '다음 페이지 다시 시도',
            isLoading: vm.isLoadingMore,
            onPressed: vm.phase == LoadPhase.ready ? vm.loadNextPage : null,
          ),
        ],
      ),
    );
  }
}
