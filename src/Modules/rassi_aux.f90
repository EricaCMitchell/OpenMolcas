      Module RASSI_AUX
      Integer, Allocatable:: TocM(:), jDisk_TDM(:,:)

      Contains

      Integer Function iDisk_TDM(I,J,K)
      Integer I, J, I_Max, J_Min, K
      I_Max=Max(I,J)
      J_Min=Min(I,J)
      iDisk_TDM=jDisk_TDM(K,I_Max*(I_Max-1)/2+J_Min)
      End Function iDisk_TDM

      End Module RASSI_AUX
