/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package data;

/**
 *
 * @author xavier
 */
public class Item {
    //<editor-fold defaultstate="collapsed" desc="FIELDS">
    //entry autoincrement
    private int _class, _subclass;
    private String _naam, _description;
    private int _displayid;
    //private int _Quality;
    //private int _Flags;  donors always account bound
    //private int _FlagsExtra;
    private int _InventoryType;
    private int _AllowableClass = -1;
    private int _AllowableRace = -1;
    private int _RequiredLevel = 1;
    private int _ItemLevel = 277;
    private int _StatsCount = 10;
    private int _stat_type1,_stat_type2,_stat_type3,_stat_type4,_stat_type5,_stat_type6,_stat_type7,_stat_type8,_stat_type9,_stat_type10;
    private int _stat_value1, _stat_value2, _stat_value3, _stat_value4, _stat_value5, _stat_value6, _stat_value7, _stat_value8, _stat_value9, _stat_value10;
    //maximum 250 res / item
    private int _armor, _holy_res, _fire_res, _nature_res, _frost_res, _shadow_res;
    //for spells, people should fill in spell id but other values should be obtained from the blizzard db values
    private int _spellid_1, _spellid_2, _spelltrigger_1,_spelltrigger_2,_spellcharges_1,_spellcharges_2,_spellcooldown_1,_spellcooldown_2;
    private int _bonding;
    private int _MaxDurability;
    private int _TotemCategory;
    private int _socketColor_1,_socketColor_2,_socketColor_3,_socketContent_1,_socketContent_2,_socketContent_3;
    private int _socketBonus;
    private int _wdbVerified = 12340;
    // </editor-fold>
    
    //<editor-fold defaultstate="collapsed" desc="GETTERS AND SETTERS">
    public int getClassItem() {
        return _class;
    }

    public void setClassItem(int _class) {
        this._class = _class;
    }

    public int getSubclass() {
        return _subclass;
    }

    public void setSubclass(int _subclass) {
        this._subclass = _subclass;
    }

    public String getNaam() {
        return _naam;
    }

    public void setNaam(String _naam) {
        this._naam = _naam;
    }

    public String getDescription() {
        return _description;
    }

    public void setDescription(String _description) {
        this._description = _description;
    }

    public int getDisplayid() {
        return _displayid;
    }

    public void setDisplayid(int _displayid) {
        this._displayid = _displayid;
    }

    public int getInventoryType() {
        return _InventoryType;
    }

    public void setInventoryType(int _InventoryType) {
        this._InventoryType = _InventoryType;
    }

    public int getAllowableClass() {
        return _AllowableClass;
    }

    public void setAllowableClass(int _AllowableClass) {
        this._AllowableClass = _AllowableClass;
    }

    public int getAllowableRace() {
        return _AllowableRace;
    }

    public void setAllowableRace(int _AllowableRace) {
        this._AllowableRace = _AllowableRace;
    }

    public int getRequiredLevel() {
        return _RequiredLevel;
    }

    public void setRequiredLevel(int _RequiredLevel) {
        this._RequiredLevel = _RequiredLevel;
    }

    public int getItemLevel() {
        return _ItemLevel;
    }

    public void setItemLevel(int _ItemLevel) {
        this._ItemLevel = _ItemLevel;
    }

    public int getStatsCount() {
        return _StatsCount;
    }

    public void setStatsCount(int _StatsCount) {
        this._StatsCount = _StatsCount;
    }

    public int getStat_type1() {
        return _stat_type1;
    }

    public void setStat_type1(int _stat_type1) {
        this._stat_type1 = _stat_type1;
    }

    public int getStat_type2() {
        return _stat_type2;
    }

    public void setStat_type2(int _stat_type2) {
        this._stat_type2 = _stat_type2;
    }

    public int getStat_type3() {
        return _stat_type3;
    }

    public void setStat_type3(int _stat_type3) {
        this._stat_type3 = _stat_type3;
    }

    public int getStat_type4() {
        return _stat_type4;
    }

    public void setStat_type4(int _stat_type4) {
        this._stat_type4 = _stat_type4;
    }

    public int getStat_type5() {
        return _stat_type5;
    }

    public void setStat_type5(int _stat_type5) {
        this._stat_type5 = _stat_type5;
    }

    public int getStat_type6() {
        return _stat_type6;
    }

    public void setStat_type6(int _stat_type6) {
        this._stat_type6 = _stat_type6;
    }

    public int getStat_type7() {
        return _stat_type7;
    }

    public void setStat_type7(int _stat_type7) {
        this._stat_type7 = _stat_type7;
    }

    public int getStat_type8() {
        return _stat_type8;
    }

    public void setStat_type8(int _stat_type8) {
        this._stat_type8 = _stat_type8;
    }

    public int getStat_type9() {
        return _stat_type9;
    }

    public void setStat_type9(int _stat_type9) {
        this._stat_type9 = _stat_type9;
    }

    public int getStat_type10() {
        return _stat_type10;
    }

    public void setStat_type10(int _stat_type10) {
        this._stat_type10 = _stat_type10;
    }

    public int getStat_value1() {
        return _stat_value1;
    }

    public void setStat_value1(int _stat_value1) {
        this._stat_value1 = _stat_value1;
    }

    public int getStat_value2() {
        return _stat_value2;
    }

    public void setStat_value2(int _stat_value2) {
        this._stat_value2 = _stat_value2;
    }

    public int getStat_value3() {
        return _stat_value3;
    }

    public void setStat_value3(int _stat_value3) {
        this._stat_value3 = _stat_value3;
    }

    public int getStat_value4() {
        return _stat_value4;
    }

    public void setStat_value4(int _stat_value4) {
        this._stat_value4 = _stat_value4;
    }

    public int getStat_value5() {
        return _stat_value5;
    }

    public void setStat_value5(int _stat_value5) {
        this._stat_value5 = _stat_value5;
    }

    public int getStat_value6() {
        return _stat_value6;
    }

    public void setStat_value6(int _stat_value6) {
        this._stat_value6 = _stat_value6;
    }

    public int getStat_value7() {
        return _stat_value7;
    }

    public void setStat_value7(int _stat_value7) {
        this._stat_value7 = _stat_value7;
    }

    public int getStat_value8() {
        return _stat_value8;
    }

    public void setStat_value8(int _stat_value8) {
        this._stat_value8 = _stat_value8;
    }

    public int getStat_value9() {
        return _stat_value9;
    }

    public void setStat_value9(int _stat_value9) {
        this._stat_value9 = _stat_value9;
    }

    public int getStat_value10() {
        return _stat_value10;
    }

    public void setStat_value10(int _stat_value10) {
        this._stat_value10 = _stat_value10;
    }

    public int getArmor() {
        return _armor;
    }

    public void setArmor(int _armor) {
        this._armor = _armor;
    }

    public int getHoly_res() {
        return _holy_res;
    }

    public void setHoly_res(int _holy_res) {
        this._holy_res = _holy_res;
    }

    public int getFire_res() {
        return _fire_res;
    }

    public void setFire_res(int _fire_res) {
        this._fire_res = _fire_res;
    }

    public int getNature_res() {
        return _nature_res;
    }

    public void setNature_res(int _nature_res) {
        this._nature_res = _nature_res;
    }

    public int getFrost_res() {
        return _frost_res;
    }

    public void setFrost_res(int _frost_res) {
        this._frost_res = _frost_res;
    }

    public int getShadow_res() {
        return _shadow_res;
    }

    public void setShadow_res(int _shadow_res) {
        this._shadow_res = _shadow_res;
    }

    public int getSpellid_1() {
        return _spellid_1;
    }

    public void setSpellid_1(int _spellid_1) {
        this._spellid_1 = _spellid_1;
    }

    public int getSpellid_2() {
        return _spellid_2;
    }

    public void setSpellid_2(int _spellid_2) {
        this._spellid_2 = _spellid_2;
    }

    public int getSpelltrigger_1() {
        return _spelltrigger_1;
    }

    public void setSpelltrigger_1(int _spelltrigger_1) {
        this._spelltrigger_1 = _spelltrigger_1;
    }

    public int getSpelltrigger_2() {
        return _spelltrigger_2;
    }

    public void setSpelltrigger_2(int _spelltrigger_2) {
        this._spelltrigger_2 = _spelltrigger_2;
    }

    public int getSpellcharges_1() {
        return _spellcharges_1;
    }

    public void setSpellcharges_1(int _spellcharges_1) {
        this._spellcharges_1 = _spellcharges_1;
    }

    public int getSpellcharges_2() {
        return _spellcharges_2;
    }

    public void setSpellcharges_2(int _spellcharges_2) {
        this._spellcharges_2 = _spellcharges_2;
    }

    public int getSpellcooldown_1() {
        return _spellcooldown_1;
    }

    public void setSpellcooldown_1(int _spellcooldown_1) {
        this._spellcooldown_1 = _spellcooldown_1;
    }

    public int getSpellcooldown_2() {
        return _spellcooldown_2;
    }

    public void setSpellcooldown_2(int _spellcooldown_2) {
        this._spellcooldown_2 = _spellcooldown_2;
    }

    public int getBonding() {
        return _bonding;
    }

    public void setBonding(int _bonding) {
        this._bonding = _bonding;
    }

    public int getMaxDurability() {
        return _MaxDurability;
    }

    public void setMaxDurability(int _MaxDurability) {
        this._MaxDurability = _MaxDurability;
    }

    public int getTotemCategory() {
        return _TotemCategory;
    }

    public void setTotemCategory(int _TotemCategory) {
        this._TotemCategory = _TotemCategory;
    }

    public int getSocketColor_1() {
        return _socketColor_1;
    }

    public void setSocketColor_1(int _socketColor_1) {
        this._socketColor_1 = _socketColor_1;
    }

    public int getSocketColor_2() {
        return _socketColor_2;
    }

    public void setSocketColor_2(int _socketColor_2) {
        this._socketColor_2 = _socketColor_2;
    }

    public int getSocketColor_3() {
        return _socketColor_3;
    }

    public void setSocketColor_3(int _socketColor_3) {
        this._socketColor_3 = _socketColor_3;
    }

    public int getSocketContent_1() {
        return _socketContent_1;
    }

    public void setSocketContent_1(int _socketContent_1) {
        this._socketContent_1 = _socketContent_1;
    }

    public int getSocketContent_2() {
        return _socketContent_2;
    }

    public void setSocketContent_2(int _socketContent_2) {
        this._socketContent_2 = _socketContent_2;
    }

    public int getSocketContent_3() {
        return _socketContent_3;
    }

    public void setSocketContent_3(int _socketContent_3) {
        this._socketContent_3 = _socketContent_3;
    }

    public int getSocketBonus() {
        return _socketBonus;
    }

    public void setSocketBonus(int _socketBonus) {
        this._socketBonus = _socketBonus;
    }

    public int getWdbVerified() {
        return _wdbVerified;
    }

    public void setWdbVerified(int _wdbVerified) {
        this._wdbVerified = _wdbVerified;
    }
    // </editor-fold>
    
    
    @Override
    public String toString() {
        return "Item{" + "_naam=" + _naam + '}';
    }

    public Item() {
    }
    
    
    
    
}   
