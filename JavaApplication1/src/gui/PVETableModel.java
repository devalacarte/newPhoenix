/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package gui;

import data.PVEReport;
import java.util.ArrayList;
import java.util.List;
import javax.swing.table.AbstractTableModel;
/**
 *
 * @author xavier
 */
public class PVETableModel extends AbstractTableModel{
    private List<PVEReport> reports = new ArrayList<>();
    private String[] columnNames = {"KillerName", "KillerGuid", "KillerAccount", "ItemEntry", "ItemGuid", "KilledName", "KilledGuid", "KilledAccount","AreaId","ZoneId"};

    public PVETableModel() {
    }

    public List<PVEReport> getReports() {
        return reports;
    }

    public void setreports(List<PVEReport> reports) {
        this.reports = reports;
    }

    public PVEReport getReportFromSelectedRow(int rownumber) {
        if (rownumber >= 0 && rownumber < reports.size()) {
            return reports.get(rownumber);
        } else {
            return null;
        }
    }

    @Override
    public String getColumnName(int col) {
        return columnNames[col];
    }

    @Override
    public int getRowCount() {
        return reports.size();
    }

    @Override
    public int getColumnCount() {
        return columnNames.length;
    }

    @Override
    public Object getValueAt(int rowIndex, int columnIndex) {
        switch (columnIndex) {
            case 0:
                return reports.get(rowIndex).getKillerName();
            case 1:
                return reports.get(rowIndex).getKillerGuid();
            case 2:
                return reports.get(rowIndex).getKillerAccount();
            case 3:
                return reports.get(rowIndex).getItemEntry();
            case 4:
                return reports.get(rowIndex).getItemGuid();
            case 5:
                return reports.get(rowIndex).getKilledName();
            case 6:
                return reports.get(rowIndex).getKilledGuid();
            case 7:
                return reports.get(rowIndex).getKilledAccount();
            case 8:
                return reports.get(rowIndex).getAreaid();
            case 9:
                return reports.get(rowIndex).getZoneid();



        }
        return "";
    }
}
