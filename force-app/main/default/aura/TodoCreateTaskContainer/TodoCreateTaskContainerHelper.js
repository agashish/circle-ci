({
	_PASSED_: function() {
        return (input) => {
            if($(input).val() == '') return false;
            return true;
        }
	}
})