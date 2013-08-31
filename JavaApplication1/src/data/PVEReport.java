/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package data;

/**
 *
 * @author xavier
 */
public class PVEReport {
    //<editor-fold defaultstate="collapsed" desc="FIELDS">
    private String _killerName;
    private int _killerGuid;
    private int _killerAccount;
    private int _itemEntry;
    private int _itemGuid;
    private String _killedName;
    private int _killedGuid;
    private int _killedAccount;
    private int _areaid;
    private int _zoneid;

    // </editor-fold>
    
    
    //<editor-fold defaultstate="collapsed" desc="GETTERS AND SETTERS">
    public String getKillerName() {
        return _killerName;
    }

    public void setKillerName(String _killerName) {
        this._killerName = _killerName;
    }

    public int getKillerGuid() {
        return _killerGuid;
    }

    public void setKillerGuid(int _killerGuid) {
        this._killerGuid = _killerGuid;
    }

    public int getKillerAccount() {
        return _killerAccount;
    }

    public void setKillerAccount(int _killerAccount) {
        this._killerAccount = _killerAccount;
    }

    public int getItemEntry() {
        return _itemEntry;
    }

    public void setItemEntry(int _itemEntry) {
        this._itemEntry = _itemEntry;
    }

    public int getItemGuid() {
        return _itemGuid;
    }

    public void setItemGuid(int _itemGuid) {
        this._itemGuid = _itemGuid;
    }

    public String getKilledName() {
        return _killedName;
    }

    public void setKilledName(String _killedName) {
        this._killedName = _killedName;
    }

    public int getKilledGuid() {
        return _killedGuid;
    }

    public void setKilledGuid(int _killedGuid) {
        this._killedGuid = _killedGuid;
    }

    public int getKilledAccount() {
        return _killedAccount;
    }

    public void setKilledAccount(int _killedAccount) {
        this._killedAccount = _killedAccount;
    }

    public int getAreaid() {
        return _areaid;
    }

    public void setAreaid(int _areaid) {
        this._areaid = _areaid;
    }

    public int getZoneid() {
        return _zoneid;
    }

    public void setZoneid(int _zoneid) {
        this._zoneid = _zoneid;
    }
    
    
    // </editor-fold>
    public PVEReport() {
    }

    public PVEReport(String _killerName, int _killerGuid, int _killerAccount, int _itemEntry, int _itemGuid, String _killedName, int _killedGuid, int _killedAccount, int _areaid, int _zoneid) {
        this._killerName = _killerName;
        this._killerGuid = _killerGuid;
        this._killerAccount = _killerAccount;
        this._itemEntry = _itemEntry;
        this._itemGuid = _itemGuid;
        this._killedName = _killedName;
        this._killedGuid = _killedGuid;
        this._killedAccount = _killedAccount;
        this._areaid = _areaid;
        this._zoneid = _zoneid;
    }
    
    
    
}
