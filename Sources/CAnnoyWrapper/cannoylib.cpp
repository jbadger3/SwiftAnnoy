//
//  cannoylib.cpp
//  SwiftAnnoy
//
//  Created by Jonathan Badger on 5/2/20.
//  Copyright © 2020 Jonathan Badger. All rights reserved.
//
#include "cannoylib.hpp"
#include "annoylib.h"
#include "kissrandom.h"
#include <stdio.h>


const void * C_initializeAnnoyIndex(int f, char* dist_metric, char* dtype) {
    if (strcmp(dtype, "Float") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = new Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = new Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = new Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = new Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy>(f);
            return (void *)index;
        }
    } else if (strcmp(dtype, "Double") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = new Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = new Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = new Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy>(f);
            return (void *)index;
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = new Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy>(f);
            return (void *)index;
        }
    }
    int fail = -1;
    int* failPtr = &fail;
    return (void *)failPtr;
}



bool C_add_item(int i, void* vector, char* dist_metric, char* dtype, const void* indexPointer) {
    if (strcmp(dtype, "Float") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            const float *vec = (const float *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            const float *vec = (const float *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            const float *vec = (const float *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            const float *vec = (const float *)vector;
            return index->add_item(i, vec);
        }
    } else if (strcmp(dtype, "Double") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            const double *vec = (const double *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            const double *vec = (const double *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            const double *vec = (const double *)vector;
            return index->add_item(i, vec);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            const double *vec = (const double *)vector;
            return index->add_item(i, vec);
        }
    }
    return false;
}

bool C_build(int num_trees, char * dist_metric, char* dtype, const void* indexPointer) {
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    return index->build(num_trees);
}

bool C_unbuild(const void* indexPointer) {
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    return index->unbuild();
}

bool C_save(const char* filename, bool prefault, const void* indexPointer) {
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    return index->save(filename, prefault);
}

void C_unload(const void* indexPointer) {
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    index->unload();
}

bool C_load(const char* filename, char* dist_metric, char* dtype, bool prefault, const void* indexPointer) {
    if (strcmp(dtype, "Float") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            return index->load(filename, prefault);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            return index->load(filename, prefault);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            return index->load(filename, prefault);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            return index->load(filename, prefault);
        }
    } else if (strcmp(dtype, "Double") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            return index->load(filename, prefault);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            return index->load(filename, prefault);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random,  Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            return index->load(filename, prefault);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            return index->load(filename, prefault);
        }
    }
    return false;
}


void C_get_distance(int i, int j, void* result, char* dist_metric, char* dtype, const void* indexPointer){
    if (strcmp(dtype, "Float") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            float dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            float dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            float dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            float dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
    } else if (strcmp(dtype, "Double") == 0) {
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            double dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            double dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            double dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            double dist = index->get_distance(i, j);
            memcpy(result, &dist, sizeof(dist));
        }
    }
}

void C_get_nns_by_item(int item, int n, int search_k, int* results, void* distances,char * dist_metric, char* dtype, const void* indexPointer) {
    if (strcmp(dtype, "Float") == 0) {
        std::vector<int> res;
        std::vector<float> dis;
        float* distancesBuffer = (float *)distances;
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);

        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        for (int i = 0; i < res.size(); i++){
            results[i] = res[i];
            distancesBuffer[i] = dis[i];
        }
    } else if (strcmp(dtype, "Double") == 0) {
        std::vector<int> res;
        std::vector<double> dis;
        double* distancesBuffer = (double *)distances;
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_item(item, n, search_k, &res, &dis);
        }
        for (int i = 0; i < res.size(); i++){
            results[i] = res[i];
            distancesBuffer[i] = dis[i];
        }
    }
}

void C_get_nns_by_vector(void* vector, int n, int search_k, int* results, void* distances, char * dist_metric, char* dtype, const void* indexPointer) {
    if (strcmp(dtype, "Float") == 0) {
        std::vector<int> res;
        std::vector<float> dis;
        const float *vec = (float *)vector;
        float* distancesBuffer = (float *)distances;
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random,Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);

        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        for (int i = 0; i < res.size(); i++){
            results[i] = res[i];
            distancesBuffer[i] = dis[i];
        }
    } else if (strcmp(dtype, "Double") == 0) {
        std::vector<int> res;
        std::vector<double> dis;
        const double *vec = (double *)vector;
        double* distancesBuffer = (double *)distances;
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_nns_by_vector(vec, n, search_k, &res, &dis);
        }
        for (int i = 0; i < res.size(); i++){
            results[i] = res[i];
            distancesBuffer[i] = dis[i];
        }
    }
}


int C_get_n_items(const void* indexPointer) {
    //The actual underlying type does not matter for this func
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    int n_items = index->get_n_items();
    return n_items;
}

int C_get_n_trees(const void* indexPointer) {
    //The actual underlying type does not matter for this func
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    int n_trees = index->get_n_trees();
    return n_trees;
}

void C_verbose(bool v, const void* indexPointer) {
    //The actual underlying type does not matter for this func
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    index->verbose(v);
}

void C_get_item(int item, void* vector, char* dist_metric, char* dtype, const void* indexPointer){
    if (strcmp(dtype, "Float") == 0) {
        float* vec = (float *)vector;
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_item(item, vec);
        }
    } else if (strcmp(dtype, "Double") == 0) {
        double* vec = (double *)vector;
        if (strcmp(dist_metric, "euclidean") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "manhattan") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Manhattan, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "dotProduct") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::DotProduct, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_item(item, vec);
        }
        else if (strcmp(dist_metric, "angular") == 0) {
            Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, double, Annoy::Angular, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
            index->get_item(item, vec);
        }
    }
}

void C_set_seed(int q, const void* indexPointer) {
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    index->set_seed(q);
}

bool C_on_disk_build(const char* filename, const void* indexPointer) {
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    return index->on_disk_build(filename);
}

void C_deleteAnnoyIndex(const void* indexPointer) {
    Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *index = (Annoy::AnnoyIndex<int, float, Annoy::Euclidean, Annoy::Kiss32Random, Annoy::AnnoyIndexSingleThreadedBuildPolicy> *)indexPointer;
    index->unbuild();
    delete index;
}


