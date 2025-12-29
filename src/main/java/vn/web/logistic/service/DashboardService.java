package vn.web.logistic.service;

import vn.web.logistic.dto.response.ChartResponse;
import vn.web.logistic.dto.response.DashboardKpiResponse;
import vn.web.logistic.repository.projection.TopPerformerProjection;

import java.util.List;

public interface DashboardService {

    // 1. KPI: Lấy chỉ số tổng hợp
    DashboardKpiResponse getKpi();

    // 2. Chart: Lấy dữ liệu biểu đồ doanh thu (đã format cho FE)
    ChartResponse getRevenueChartData();

    // 3. Top Lists: Lấy danh sách Hub và Shipper hiệu suất cao
    List<TopPerformerProjection> getTopHubs();

    List<TopPerformerProjection> getTopShippers();
}