import 'package:built_collection/built_collection.dart';
import 'package:built_value/serializer.dart';
import 'package:built_value/standard_json_plugin.dart';
import 'package:wallpaperApp/Models/hits.dart';
import 'package:wallpaperApp/Models/wallpaper.dart';

part 'serializers.g.dart';

@SerializersFor(const[Wallpaper,Hits])
final Serializers serializers=(_$serializers.toBuilder()..addPlugin(StandardJsonPlugin())).build();

T deserialize<T>(dynamic value)=>serializers.deserializeWith<T>(serializers.serializerForType(T),value);

BuiltList<T> deserializeListOf<T>(dynamic value)=>BuiltList.from(value.map((value)=>deserialize<T>(value)).toList(growable:false));
