import 'package:flutter/material.dart';
import 'package:pricely/model/item.dart';

class ListGriditemWidget extends StatefulWidget {
  const ListGriditemWidget(this.items, {Key? key, this.title = ''})
      : super(key: key);

  final String title;
  final List<Item> items;

  @override
  _ListGriditemWidgetState createState() => _ListGriditemWidgetState();
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
              overflow: TextOverflow.ellipsis,
            ),
            //Image grid
            Expanded(
              child: Builder(builder: (context) {
                return GridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 2,
                  crossAxisSpacing: 2,
                  semanticChildCount: 4,
                  //Get the max height from the parent

                  padding: const EdgeInsets.all(2),
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(
                    4,
                    (index) {
                      return (index < widget.items.length &&
                              widget.items[index].image != null)
                          ? Image(
                              image: widget.items[index].image!,
                              fit: BoxFit.cover,
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                );
              }),
            ),
            Text(
              'Itens: ${widget.items.length}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
