package vn.web.logistic.service;

import vn.web.logistic.dto.response.TransportReportResponse;
import vn.web.logistic.dto.response.TransportStatsResponse;

import java.time.LocalDate;

public interface TransportStatsService {

    TransportStatsResponse getTransportStats();

    TransportReportResponse getTransportReport(LocalDate fromDate, LocalDate toDate);
}
