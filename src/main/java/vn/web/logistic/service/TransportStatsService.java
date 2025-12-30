package vn.web.logistic.service;

import java.time.LocalDate;

import vn.web.logistic.dto.response.admin.TransportReportResponse;
import vn.web.logistic.dto.response.admin.TransportStatsResponse;

public interface TransportStatsService {

    TransportStatsResponse getTransportStats();

    TransportReportResponse getTransportReport(LocalDate fromDate, LocalDate toDate);
}
