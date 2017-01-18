angular.module('metaLogin').service('KeyValueService', ['$resource', function ($resource) {

	var KeyValueResource = $resource('/keyvalue/:keyName/:operation', {
		keyName: '@keyName'
	}, {
		generateOTP: {
			method: 'PUT',
			params: {operation: 'generate_otp_for_sign_up'}
		},
		otpVerification: {
			method: 'PUT',
			params: {operation: 'otp_verification'}
		}
	});
	return KeyValueResource;
}]);
