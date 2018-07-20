# coding: utf-8
class Item
  attr_accessor :count
  def initialize(*)
    @count = 1
  end

  def same(_)
    false
  end

  def mass
    @count
  end

  def add!(other)
    raise 'not same' unless same(other)
    @count += other.count
    self
  end

  def +(other)
    clone.add! other
  end

  def multiplicate!(other)
    raise 'not number 0..2000' unless (0..2000).cover? other
    raise "our count, being #{@count}, is not in 0..2000" unless (0..2000).cover? @count
    raise 'more than 2000' unless other.between?(0, 2000 / @count)
    @count *= other
    self
  end

  def *(other)
    clone.multiplicate! other
  end

  def encapsulable
    true
  end

  def itemkind_string
    "<>"
  end

  def itemline
    "#{self.itemkind_string}\t#{self.count}"
  end
end
RARITYDICTIONARYTOLINE = {common: 'c', rare: 'r', veryrare: 'vr'}.freeze
class Shield < Item
  RARITIES = %i[common rare veryrare axa].freeze
  attr_reader :rarity

  def initialize(rarity)
    super
    @rarity = rarity
    check_rarity_right
  end

  def type
    :shield
  end

  def check_rarity_right
    raise 'bad shield rarity' unless RARITIES.include? @rarity
  end

  def same(y)
    type == y.type && @rarity == y.rarity
  end

  def itemkind_string
    check_rarity_right
    case @rarity
    when :axa
      return "axa"
    end
    return "#{RARITYDICTIONARYTOLINE[@rarity]}sh"
  end
end
class RarityItem < Item
  RARITIES = %i[common rare veryrare].freeze

  def initialize(rarity)
    super
    @rarity = rarity
    check_rarity_right
  end

  def check_rarity_right
    raise 'bad rarity' unless RARITIES.include? @rarity
  end

  def same(y)
    type == y.type && rarity == y.rarity
  end
end
class HackMod < RarityItem
  TYPES = %i[heatsink multihack].freeze
end
class HeatSink < HackMod
  def initialize(*)
    super
  end

  def type
    :heatsink
  end
end
class MultiHack < HackMod
  def initialize(*)
    super
  end

  def type
    :multihack
  end
end
class Transmuter < Item
  attr_reader :itotype
  ITOTYPES = %i[minus plus].freeze

  def initialize(itotype)
    super
    raise 'bad itotype' unless ITOTYPES.include? itotype
    @itotype = itotype
  end

  def type
    :transmuter
  end

  def same(y)
    type == y.type && @itotype == y.itotype
  end

  def plusminus
    case @itotype
    when :plus
      '+'
    when :minus
      '-'
    end
  end

  def itemkind_string
    "ito#{plusminus}"
  end
end
class NiaItem < Item
  TYPES = %i[portalfracker beacon].freeze

  def encapsulable
    false
  end
end
class PortalFracker < NiaItem
  def initialize(*)
    super
  end

  def type
    :portalfracker
  end

  def same(y)
    type == y.type
  end
end
class Beacon < NiaItem
  attr_reader :beacontype
  BEACONTYPES = %i[niantic].freeze

  def initialize(beacontype)
    super
    raise 'bad beacontype' unless BEACONTYPES.include? beacontype
    @beacontype = beacontype
  end

  def type
    :beacon
  end

  def same(y)
    type == y.type && @beacontype == y.beacontype
  end
end
class FlipVirus < Item
  attr_reader :virustype
  VIRUSTYPES = %i[ada jarvis].freeze

  def initialize(virustype)
    super
    raise 'bad virustype' unless VIRUSTYPES.include? virustype
    @virustype = virustype
  end

  def type
    :flipvirus
  end

  def same(y)
    type == y.type && @virustype == y.virustype
  end
end
class LeveledItem < Item
  attr_reader :level
  TYPES = %i[resonator xmp ultrastrike].freeze
  LEVELS = [1, 2, 3, 4, 5, 6, 7, 8].freeze

  def initialize(level)
    super
    raise 'bad leveleditem level' unless LEVELS.include? level
    @level = level
  end

  def same(y)
    type == y.type && @level == y.level
  end
end
class Bomb < LeveledItem
  TYPES = %i[xmp ultrastrike].freeze
end
class XMP < Bomb
  def initialize(*)
    super
  end

  def type
    :xmp
  end
end
class UltraStrike < Bomb
  def initialize(*)
    super
  end

  def type
    :ultrastrike
  end
end
class Resonator < LeveledItem
  def initialize(*)
    super
  end
  def type
    :resonator
  end
end
class PowerCube < Item
  attr_reader :level
  LEVELS = [1, 2, 3, 4, 5, 6, 7, 8, :circlek, :lawson].freeze

  def initialize(level)
    super
    raise 'bad powercube level' unless LEVELS.include? level
    @level = level
  end

  def type
    :powercube
  end

  def same(y)
    type == y.type && @level == y.level
  end
end
class LinkAmping < Item
  TYPES = %i[linkamp softbankultralink].freeze
end
class LinkAmp < LinkAmping
  def initialize(*)
    super
  end

  def type
    :linkamp
  end
end
class SoftBankUltraLink < LinkAmping
  def initialize(*)
    super
  end

  def type
    :softbankultralink
  end
end
class FAT < Item
  attr_reader :fattype
  FATTYPES = %i[forceamp turret].freeze
  def initialize(fattype)
    super
    raise 'bad fattype' unless FATTYPES.include? fattype
    @fattype = fattype
  end

  def type
    :fat
  end
end
class Key < Item
  attr_reader :keykind
  KEYKINDS = %i[there from souvenir].freeze

  def initialize(keykind)
    super
    raise 'bad keykind' unless KEYKINDS.include? keykind
    @keykind = keykind
  end

  def type
    :key
  end

  def same(y)
    type == y.type && @keykind == y.keykind
  end
end
class OtherSouvenir < Item
  attr_reader :description
  def initialize(description)
    super
    @description = description
  end

  def type
    :othersouvenir
  end

  def same(other)
    type == other.type && @description == other.description
  end
end
class VolumeDoesntMatchContains < StandardError
  def initialize; end

  def reason
    'volume doesnt match contains'
  end
end
def alltrue(arr)
  arr.reduce(true) { |acc, that| acc && that }
end
class Capsuling < Item
  attr_writer :id
  attr_writer :volume
  attr_writer :contains
  KINDS = %i[capsule quantum keylocker].freeze
  def initialize(id = nil, volume = 0, contains = [])
    super
    @id = id
    @volume = volume
    @contains = contains
    raise 'contains is not an array' unless contains.is_a?(Array)
    raise 'volume is not between 0 and 100' unless (0..100).cover? volume
    check_if_contains_just_items
    check_volume_match
  end

  def type
    :capsule
  end

  def check_if_contains_just_items
    raise 'not all are items' unless alltrue(@contains.collect { |x| x.same(x) })
  end

  def volume_match?
    @contains
      .collect(&:count)
      .reduce(0) { |a, n| a + n } == @volume
  end

  def check_volume_match
    check_if_contains_just_items
    raise VolumeDoesntMatchContains unless volume_match?
  end

  def same(y)
    type == y.type && @kind == y.kind && @id == y.id && @volume == y.volume && @contains == y.contains
  end

  def mass
    @count + @volume
  end

  def encapsulable
    false
  end
end
class JustCapsule < Capsuling
  def initialize(*)
    super
  end

  def kind
    :capsule
  end
end
class QuantumCapsule < JustCapsule
  def initialize(*)
    super
  end

  def kind
    :quantum
  end
end
class KeyLocker < Capsuling
  def initialize(id = '', volume = 0, contains = [])
    super
    raise 'not all are keys' unless check_if_contains_just_keys
  end

  def kind
    :keylocker
  end

  def check_if_contains_just_keys
    alltrue(@contains.collect { |x| x.type == :key })
  end

  def check_if_contains_just_items
    super
    check_if_contains_just_keys
  end
end

def rarity_parse(rarity)
  case rarity
  when "c"
    return :common
  when 'r'
    return :rare
  when 'vr'
    return :veryrare
  end
  raise "bad rarity: -#{rarity[0]},#{rarity[1]},#{rarity[2]}-, 'c'==#{'c'==rarity}"
end

def interpret_item_kind(kind)
  if %r{\A(?<what>[rxuq])(?<level>[1-8])\z} =~ kind
    level = Integer(level)
    case what
    when 'r'
      Resonator.new(level)
    when 'x'
      XMP.new(level)
    when 'u'
      UltraStrike.new(level)
    when 'q'
      PowerCube.new(level)
    end
  elsif %r{\Aq(?<level>(cirk|laws))\z} =~ kind
    PowerCube.new case level
                  when 'cirk'
                    :circlek
                  when 'laws'
                    :lawson
                  end
  elsif %r{\A(?<rarity>(c|r|vr))(?<what>(sh|hs|mh))\z} =~ kind
    rarity = rarity_parse rarity
    case what
    when 'sh'
      Shield.new(rarity)
    when 'hs'
      HeatSink.new(rarity)
    when 'mh'
      MultiHack.new(rarity)
    end
  elsif kind == 'axa'
    Shield.new(:axa)
  elsif kind == 'pfr'
    PortalFracker.new
  elsif %r{\Abea(?<beacon>nia)\z} =~ kind
    Beacon.new case beacon
               when 'nia'
                 :niantic
               end
  elsif kind == 'sbul'
    SoftBankUltraLink.new
  elsif kind == 'la'
    LinkAmp.new
  elsif kind == 'fa'
    FAT.new :forceamp
  elsif kind == 't'
    FAT.new :turret
  elsif %r{\Ak_(?<keykind>(souv|ther|from))\z} =~ kind
    Key.new case keykind
            when 'souv'
              :souvenir
            when 'ther'
              :there
            when 'from'
              :from
            end
  elsif %r{\A(?<desc>o_souv)\z} =~ kind
    OtherSouvenir.new desc
  elsif %r{\Aito(?<itotype>[+\-])\z} =~ kind
    Transmuter.new case itotype
                   when '+'
                     :plus
                   when '-'
                     :minus
                   end
  elsif %r{\Acap_(?<captype>(qe|ke|[kq_e]))\z} =~ kind
    id = ''
    case captype[-1]
    when 'e'
      id = nil
    end
    case captype[0]
    when 'q'
      QuantumCapsule.new id
    when 'k'
      KeyLocker.new id
    when '_', 'e'
      JustCapsule.new id
    end
  end
end

def read_one_contained(one)
  raise 'there is no colon separating count' unless
    %r{\A(?<kind>[a-z][a-z1-8_\-+]):(?<count>\d\d?\d?)\z} =~ one
  interpret_item_kind(kind).multiplicate!(Integer(count)).freeze
end

def read_cont(cont)
  cont.split(',').freeze.collect { |x| read_one_contained x }.freeze
end

def read_caps(caps)
  l = caps.split('/').freeze
  [Integer(l[0]), read_cont(l[1])].freeze
end

def read_line(line)
  t = line.split("\t").freeze
  return nil if t.count.zero?
  raise 'tylko jeden wut' if t.count == 1
  # if t.count >= 2
  itemkind = interpret_item_kind t[0]
  if t[1] =~ %r{\A\d{1,4}\z}
    count = Integer t[1]
    return itemkind.multiplicate!(count).freeze
  elsif t[1] =~ %r{\A\h{8}\z}
    itemkind.id = t[1]
    if t.count >= 3 &&
       t[2] =~ %r{\A(\d\d?\d?\/)?([a-z][a-z1-8_\-+]:\d\d?\d?,?)+\z}
      volume, contains = read_caps t[2]
      itemkind.volume = volume
      itemkind.contains = contains
    end
    return itemkind.freeze
  end
  raise "to nie to #{t} :("
end

def read_from(filename)
  t, *e = IO.readlines(filename)
  [Integer(t), e.collect { |x| read_line x.chomp }].freeze
end
