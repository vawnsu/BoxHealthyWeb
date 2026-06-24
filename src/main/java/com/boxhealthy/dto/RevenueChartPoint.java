package com.boxhealthy.dto;

import java.math.BigDecimal;

public class RevenueChartPoint {
    private final String label;
    private final BigDecimal revenue;
    private final long orderCount;
    private final int percent;
    private final int x;
    private final int y;

    public RevenueChartPoint(String label, BigDecimal revenue, long orderCount, int percent, int x, int y) {
        this.label = label;
        this.revenue = revenue;
        this.orderCount = orderCount;
        this.percent = percent;
        this.x = x;
        this.y = y;
    }

    public String getLabel() {
        return label;
    }

    public BigDecimal getRevenue() {
        return revenue;
    }

    public long getOrderCount() {
        return orderCount;
    }

    public int getPercent() {
        return percent;
    }

    public int getX() {
        return x;
    }

    public int getY() {
        return y;
    }
}
