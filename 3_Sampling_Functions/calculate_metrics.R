
calculate_metrics <- function(landscape){
  dplyr::bind_rows(
    
    # Class level
    landscapemetrics::lsm_c_area_cv(landscape),
    landscapemetrics::lsm_c_area_mn(landscape),
    landscapemetrics::lsm_c_area_sd(landscape),
    
    landscapemetrics::lsm_c_cai_cv(landscape),
    landscapemetrics::lsm_c_cai_mn(landscape),
    landscapemetrics::lsm_c_cai_sd(landscape),
    
    landscapemetrics::lsm_c_circle_cv(landscape),
    landscapemetrics::lsm_c_circle_mn(landscape),
    landscapemetrics::lsm_c_circle_sd(landscape),
    
    landscapemetrics::lsm_c_cohesion(landscape),
    
    landscapemetrics::lsm_c_contig_cv(landscape),
    landscapemetrics::lsm_c_contig_mn(landscape),
    landscapemetrics::lsm_c_contig_sd(landscape),
    
    landscapemetrics::lsm_c_core_cv(landscape),
    landscapemetrics::lsm_c_core_mn(landscape),
    landscapemetrics::lsm_c_core_sd(landscape),
    
    landscapemetrics::lsm_c_cpland(landscape),
    
    landscapemetrics::lsm_c_dcad(landscape),
    
    landscapemetrics::lsm_c_dcore_cv(landscape),
    landscapemetrics::lsm_c_dcore_mn(landscape),
    landscapemetrics::lsm_c_dcore_sd(landscape),
    
    landscapemetrics::lsm_c_division(landscape),
    
    landscapemetrics::lsm_c_ed(landscape, ...),
    
    landscapemetrics::lsm_c_enn_cv(landscape),
    landscapemetrics::lsm_c_enn_mn(landscape),
    landscapemetrics::lsm_c_enn_sd(landscape),
    
    landscapemetrics::lsm_c_frac_cv(landscape),
    landscapemetrics::lsm_c_frac_mn(landscape),
    landscapemetrics::lsm_c_frac_sd(landscape),
    
    landscapemetrics::lsm_c_gyrate_cv(landscape),
    landscapemetrics::lsm_c_gyrate_mn(landscape),
    landscapemetrics::lsm_c_gyrate_sd(landscape),
    
    landscapemetrics::lsm_c_lpi(landscape),
    
    landscapemetrics::lsm_c_lsi(landscape), # ???
    
    landscapemetrics::lsm_c_mesh(landscape),
    
    landscapemetrics::lsm_c_pafrac(landscape), # Only works for > 10 patches
    
    landscapemetrics::lsm_c_para_cv(landscape),
    landscapemetrics::lsm_c_para_mn(landscape),
    landscapemetrics::lsm_c_para_sd(landscape),
    
    landscapemetrics::lsm_c_pd(landscape),
    
    landscapemetrics::lsm_c_pladj(landscape),
    
    landscapemetrics::lsm_c_pland(landscape),
    
    landscapemetrics::lsm_c_shape_cv(landscape),
    landscapemetrics::lsm_c_shape_mn(landscape),
    landscapemetrics::lsm_c_shape_sd(landscape),
    
    landscapemetrics::lsm_c_split(landscape),
    
    # Landscape level
    landscapemetrics::lsm_l_area_cv(landscape),
    landscapemetrics::lsm_l_area_mn(landscape),
    landscapemetrics::lsm_l_area_sd(landscape),
    
    landscapemetrics::lsm_l_cai_cv(landscape),
    landscapemetrics::lsm_l_cai_mn(landscape),
    landscapemetrics::lsm_l_cai_sd(landscape),
    
    landscapemetrics::lsm_l_circle_cv(landscape),
    landscapemetrics::lsm_l_circle_mn(landscape),
    landscapemetrics::lsm_l_circle_sd(landscape),
    
    landscapemetrics::lsm_l_contig_cv(landscape),
    landscapemetrics::lsm_l_contig_mn(landscape),
    landscapemetrics::lsm_l_contig_sd(landscape),
    
    landscapemetrics::lsm_l_core_cv(landscape),
    landscapemetrics::lsm_l_core_mn(landscape),
    landscapemetrics::lsm_l_core_sd(landscape),
    
    landscapemetrics::lsm_l_dcad(landscape),
    
    landscapemetrics::lsm_l_division(landscape),
    
    landscapemetrics::lsm_l_dcore_cv(landscape),
    landscapemetrics::lsm_l_dcore_mn(landscape),
    landscapemetrics::lsm_l_dcore_sd(landscape),
    
    landscapemetrics::lsm_l_ed(landscape, ...),
    
    landscapemetrics::lsm_l_enn_cv(landscape),
    landscapemetrics::lsm_l_enn_mn(landscape),
    landscapemetrics::lsm_l_enn_sd(landscape),
    
    landscapemetrics::lsm_l_frac_cv(landscape),
    landscapemetrics::lsm_l_frac_mn(landscape),
    landscapemetrics::lsm_l_frac_sd(landscape),
    
    landscapemetrics::lsm_l_gyrate_cv(landscape),
    landscapemetrics::lsm_l_gyrate_mn(landscape),
    landscapemetrics::lsm_l_gyrate_sd(landscape),
    
    landscapemetrics::lsm_l_lpi(landscape),
    
    landscapemetrics::lsm_l_lsi(landscape), # ????
    
    landscapemetrics::lsm_l_mesh(landscape),
    
    landscapemetrics::lsm_l_msidi(landscape),
    
    landscapemetrics::lsm_l_msiei(landscape),
    
    landscapemetrics::lsm_l_pafrac(landscape), # Only works for > 10 patches
    
    landscapemetrics::lsm_l_para_cv(landscape),
    landscapemetrics::lsm_l_para_mn(landscape),
    landscapemetrics::lsm_l_para_sd(landscape),
    
    landscapemetrics::lsm_l_pd(landscape),
    
    landscapemetrics::lsm_l_pladj(landscape),
    
    landscapemetrics::lsm_l_prd(landscape),
    
    landscapemetrics::lsm_l_shape_cv(landscape),
    landscapemetrics::lsm_l_shape_mn(landscape),
    landscapemetrics::lsm_l_shape_sd(landscape),
    
    landscapemetrics::lsm_l_shdi(landscape),
    
    landscapemetrics::lsm_l_shei(landscape),
    
    landscapemetrics::lsm_l_sidi(landscape),
    
    landscapemetrics::lsm_l_siei(landscape),
    
    landscapemetrics::lsm_l_split(landscape)
    )
}