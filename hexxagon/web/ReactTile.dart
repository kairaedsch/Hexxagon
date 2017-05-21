import 'dart:html';
import 'package:react/react.dart' as react;
import 'package:react/react_dom.dart' as react_dom;
import 'package:react/react_client.dart' as react_client;
import 'package:over_react/over_react.dart';

@Factory()
UiFactory<ReactTileProps> ReactTile;

@Props()
class ReactTileProps extends UiProps
{
  String width;
}

@Component()
class ReactTileComponent extends UiComponent<ReactTileProps>
{
  ReactElement render()
  {
    return (Dom.div()
      ..className = "hexagon"
      //..style = {"width": props.width}
    )(
        (Dom.div()..className = "hexagonLeft")( ),
        (Dom.div()..className = "hexagonMiddle")(),
        (Dom.div()..className = "hexagonRight")( ),
    );
  }
}