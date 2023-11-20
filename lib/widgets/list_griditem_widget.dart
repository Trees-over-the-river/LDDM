import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';

class ListGriditemWidget extends StatefulWidget {
  const ListGriditemWidget(this.items, {Key? key, this.title = ''})
      : super(key: key);

  final String title;
  final List<Item> items;

  @override
  createState() => _ListGriditemWidgetState();
}

class _ListGriditemWidgetState extends State<ListGriditemWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/items', arguments: widget.items);
      },
      child: Card(
        child: Column(
          children: [
            Text(
              widget.title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              overflow: TextOverflow.ellipsis,
            ),
            //Image grid
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(8.0),
                    bottomRight: Radius.circular(8.0),
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.count(
                    crossAxisCount: 2,
                    semanticChildCount: 4,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    physics: const NeverScrollableScrollPhysics(),
                    children: List.generate(
                      4,
                      (index) {
                        if ((index < widget.items.length &&
                            widget.items[index].image != null)) {
                          var image = Image(
                            image: widget.items[index].image!,
                            fit: BoxFit.cover,
                          );
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: (index == 3 && widget.items.length > 3)
                                ? Stack(
                                    children: [
                                      image,
                                      Container(
                                        color: Colors.black.withOpacity(0.5),
                                        child: Center(
                                          child: Text(
                                            '+${widget.items.length - 4}',
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : image,
                          );
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
