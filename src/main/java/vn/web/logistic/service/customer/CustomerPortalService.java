package vn.web.logistic.service.customer;

import java.util.List;

import vn.web.logistic.dto.request.customer.CustomerAddressForm;
import vn.web.logistic.dto.request.customer.CustomerProfileForm;
import vn.web.logistic.entity.Customer;
import vn.web.logistic.entity.CustomerAddress;

public interface CustomerPortalService {

    Customer getOrCreateCurrentCustomer();

    Customer getCurrentCustomerOrThrow();

    List<CustomerAddress> getCurrentCustomerAddresses();

    CustomerAddress addAddress(CustomerAddressForm form);

    void setDefaultAddress(Long addressId);

    void deleteAddress(Long addressId);

    void updateProfile(CustomerProfileForm form);
}
