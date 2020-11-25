import 'package:hive/hive.dart';
part 'siswa.g.dart';

@HiveType(typeId: 0)
class Siswa {
  @HiveField(0)
  String judul;
  @HiveField(1)
  String desc;
 

  Siswa(this.judul, this.desc);
}
