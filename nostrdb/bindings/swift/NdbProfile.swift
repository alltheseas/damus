// automatically generated by the FlatBuffers compiler, do not modify
// swiftlint:disable all
// swiftformat:disable all

public struct NdbProfile: FlatBufferObject, Verifiable {

  static func validateVersion() { FlatBuffersVersion_23_5_26() }
  public var __buffer: ByteBuffer! { return _accessor.bb }
  private var _accessor: Table

  private init(_ t: Table) { _accessor = t }
  public init(_ bb: ByteBuffer, o: Int32) { _accessor = Table(bb: bb, position: o) }

  private enum VTOFFSET: VOffset {
    case name = 4
    case website = 6
    case about = 8
    case lud16 = 10
    case banner = 12
    case displayName = 14
    case reactions = 16
    case picture = 18
    case nip05 = 20
    case damusDonation = 22
    case damusDonationV2 = 24
    var v: Int32 { Int32(self.rawValue) }
    var p: VOffset { self.rawValue }
  }

  public var name: String? { let o = _accessor.offset(VTOFFSET.name.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var nameSegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.name.v) }
  public var website: String? { let o = _accessor.offset(VTOFFSET.website.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var websiteSegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.website.v) }
  public var about: String? { let o = _accessor.offset(VTOFFSET.about.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var aboutSegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.about.v) }
  public var lud16: String? { let o = _accessor.offset(VTOFFSET.lud16.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var lud16SegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.lud16.v) }
  public var banner: String? { let o = _accessor.offset(VTOFFSET.banner.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var bannerSegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.banner.v) }
  public var displayName: String? { let o = _accessor.offset(VTOFFSET.displayName.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var displayNameSegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.displayName.v) }
  public var reactions: Bool { let o = _accessor.offset(VTOFFSET.reactions.v); return o == 0 ? true : _accessor.readBuffer(of: Bool.self, at: o) }
  public var picture: String? { let o = _accessor.offset(VTOFFSET.picture.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var pictureSegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.picture.v) }
  public var nip05: String? { let o = _accessor.offset(VTOFFSET.nip05.v); return o == 0 ? nil : _accessor.string(at: o) }
  public var nip05SegmentArray: [UInt8]? { return _accessor.getVector(at: VTOFFSET.nip05.v) }
  public var damusDonation: Int32 { let o = _accessor.offset(VTOFFSET.damusDonation.v); return o == 0 ? 0 : _accessor.readBuffer(of: Int32.self, at: o) }
  public var damusDonationV2: Int32 { let o = _accessor.offset(VTOFFSET.damusDonationV2.v); return o == 0 ? 0 : _accessor.readBuffer(of: Int32.self, at: o) }
  public static func startNdbProfile(_ fbb: inout FlatBufferBuilder) -> UOffset { fbb.startTable(with: 11) }
  public static func add(name: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: name, at: VTOFFSET.name.p) }
  public static func add(website: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: website, at: VTOFFSET.website.p) }
  public static func add(about: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: about, at: VTOFFSET.about.p) }
  public static func add(lud16: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: lud16, at: VTOFFSET.lud16.p) }
  public static func add(banner: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: banner, at: VTOFFSET.banner.p) }
  public static func add(displayName: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: displayName, at: VTOFFSET.displayName.p) }
  public static func add(reactions: Bool, _ fbb: inout FlatBufferBuilder) { fbb.add(element: reactions, def: true,
   at: VTOFFSET.reactions.p) }
  public static func add(picture: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: picture, at: VTOFFSET.picture.p) }
  public static func add(nip05: Offset, _ fbb: inout FlatBufferBuilder) { fbb.add(offset: nip05, at: VTOFFSET.nip05.p) }
  public static func add(damusDonation: Int32, _ fbb: inout FlatBufferBuilder) { fbb.add(element: damusDonation, def: 0, at: VTOFFSET.damusDonation.p) }
  public static func add(damusDonationV2: Int32, _ fbb: inout FlatBufferBuilder) { fbb.add(element: damusDonationV2, def: 0, at: VTOFFSET.damusDonationV2.p) }
  public static func endNdbProfile(_ fbb: inout FlatBufferBuilder, start: UOffset) -> Offset { let end = Offset(offset: fbb.endTable(at: start)); return end }
  public static func createNdbProfile(
    _ fbb: inout FlatBufferBuilder,
    nameOffset name: Offset = Offset(),
    websiteOffset website: Offset = Offset(),
    aboutOffset about: Offset = Offset(),
    lud16Offset lud16: Offset = Offset(),
    bannerOffset banner: Offset = Offset(),
    displayNameOffset displayName: Offset = Offset(),
    reactions: Bool = true,
    pictureOffset picture: Offset = Offset(),
    nip05Offset nip05: Offset = Offset(),
    damusDonation: Int32 = 0,
    damusDonationV2: Int32 = 0
  ) -> Offset {
    let __start = NdbProfile.startNdbProfile(&fbb)
    NdbProfile.add(name: name, &fbb)
    NdbProfile.add(website: website, &fbb)
    NdbProfile.add(about: about, &fbb)
    NdbProfile.add(lud16: lud16, &fbb)
    NdbProfile.add(banner: banner, &fbb)
    NdbProfile.add(displayName: displayName, &fbb)
    NdbProfile.add(reactions: reactions, &fbb)
    NdbProfile.add(picture: picture, &fbb)
    NdbProfile.add(nip05: nip05, &fbb)
    NdbProfile.add(damusDonation: damusDonation, &fbb)
    NdbProfile.add(damusDonationV2: damusDonationV2, &fbb)
    return NdbProfile.endNdbProfile(&fbb, start: __start)
  }

  public static func verify<T>(_ verifier: inout Verifier, at position: Int, of type: T.Type) throws where T: Verifiable {
    var _v = try verifier.visitTable(at: position)
    try _v.visit(field: VTOFFSET.name.p, fieldName: "name", required: false, type: ForwardOffset<String>.self)
    try _v.visit(field: VTOFFSET.website.p, fieldName: "website", required: false, type: ForwardOffset<String>.self)
    try _v.visit(field: VTOFFSET.about.p, fieldName: "about", required: false, type: ForwardOffset<String>.self)
    try _v.visit(field: VTOFFSET.lud16.p, fieldName: "lud16", required: false, type: ForwardOffset<String>.self)
    try _v.visit(field: VTOFFSET.banner.p, fieldName: "banner", required: false, type: ForwardOffset<String>.self)
    try _v.visit(field: VTOFFSET.displayName.p, fieldName: "displayName", required: false, type: ForwardOffset<String>.self)
    try _v.visit(field: VTOFFSET.reactions.p, fieldName: "reactions", required: false, type: Bool.self)
    try _v.visit(field: VTOFFSET.picture.p, fieldName: "picture", required: false, type: ForwardOffset<String>.self)
    try _v.visit(field: VTOFFSET.nip05.p, fieldName: "nip05", required: false, type: ForwardOffset<String>.self)
    try _v.visit(field: VTOFFSET.damusDonation.p, fieldName: "damusDonation", required: false, type: Int32.self)
    try _v.visit(field: VTOFFSET.damusDonationV2.p, fieldName: "damusDonationV2", required: false, type: Int32.self)
    _v.finish()
  }
}

