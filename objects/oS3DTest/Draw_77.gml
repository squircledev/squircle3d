var _state = gpu_get_state();
var _keys = ds_map_keys_to_array(_state);
var _values = ds_map_values_to_array(_state);
sd_trace(_keys);
sd_trace(_values);
gpu_set_state(_state);