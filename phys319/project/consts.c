// round a floating point to an integer
int round_(float value) {
   if (value < 0.0)
       return (int) (value - 0.5);
   else
       return (int) (value + 0.5);
}

// linearly map a value in initial range to final range
float linear_map(float value, float lower_i, float upper_i, float lower_f, float upper_f) {
   // place value within correct limits if not already
   if (value < lower_i)
       value = lower_i;
   else if (value > upper_i)
       value = upper_i;
   // map value linearly to final range
   return (value - lower_i) / (upper_i - lower_i) * (upper_f - lower_f) + lower_f;
}
