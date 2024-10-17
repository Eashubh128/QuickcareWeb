// To parse this JSON data, do
//
//     final address = addressFromJson(jsonString);

import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data.toJson());

class Address {
  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  String? lat;
  String? lon;
  String? addressClass;
  String? type;
  int? placeRank;
  double? importance;
  String? addresstype;
  String? name;
  String? displayName;
  AddressClass? address;
  List<String>? boundingbox;

  Address({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.addressClass,
    this.type,
    this.placeRank,
    this.importance,
    this.addresstype,
    this.name,
    this.displayName,
    this.address,
    this.boundingbox,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        placeId: json["place_id"],
        licence: json["licence"],
        osmType: json["osm_type"],
        osmId: json["osm_id"],
        lat: json["lat"],
        lon: json["lon"],
        addressClass: json["class"],
        type: json["type"],
        placeRank: json["place_rank"],
        importance: json["importance"]?.toDouble(),
        addresstype: json["addresstype"],
        name: json["name"],
        displayName: json["display_name"],
        address: json["address"] == null
            ? null
            : AddressClass.fromJson(json["address"]),
        boundingbox: json["boundingbox"] == null
            ? []
            : List<String>.from(json["boundingbox"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "place_id": placeId,
        "licence": licence,
        "osm_type": osmType,
        "osm_id": osmId,
        "lat": lat,
        "lon": lon,
        "class": addressClass,
        "type": type,
        "place_rank": placeRank,
        "importance": importance,
        "addresstype": addresstype,
        "name": name,
        "display_name": displayName,
        "address": address?.toJson(),
        "boundingbox": boundingbox == null
            ? []
            : List<dynamic>.from(boundingbox!.map((x) => x)),
      };
}

class AddressClass {
  String? railway;
  String? road;
  String? suburb;
  String? cityDistrict;
  String? city;
  String? state;
  String? iso31662Lvl4;
  String? postcode;
  String? country;
  String? countryCode;

  AddressClass({
    this.railway,
    this.road,
    this.suburb,
    this.cityDistrict,
    this.city,
    this.state,
    this.iso31662Lvl4,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory AddressClass.fromJson(Map<String, dynamic> json) => AddressClass(
        railway: json["railway"],
        road: json["road"],
        suburb: json["suburb"],
        cityDistrict: json["city_district"],
        city: json["city"],
        state: json["state"],
        iso31662Lvl4: json["ISO3166-2-lvl4"],
        postcode: json["postcode"],
        country: json["country"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "railway": railway,
        "road": road,
        "suburb": suburb,
        "city_district": cityDistrict,
        "city": city,
        "state": state,
        "ISO3166-2-lvl4": iso31662Lvl4,
        "postcode": postcode,
        "country": country,
        "country_code": countryCode,
      };
}
