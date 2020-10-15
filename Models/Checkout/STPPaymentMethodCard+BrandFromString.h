@import Stripe;

NS_ASSUME_NONNULL_BEGIN

@interface STPPaymentMethodCard (BrandFromString)

+ (STPCardBrand)brandFromString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
