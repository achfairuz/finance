import 'package:finance/UI/Transaction/detailTransaction.dart';
import 'package:finance/UI/components/components.dart';
import 'package:flutter/material.dart';
import 'package:finance/core/constants/constants.dart';

class MyCarts extends StatelessWidget {
  final List<Map<String, dynamic>> dataTransaction;
  final bool isLoading;

  const MyCarts(
      {super.key, required this.dataTransaction, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        : ListView.builder(
            itemBuilder: (context, index) {
              final data = dataTransaction[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Detailtransaction(data: data),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  margin: EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: AppColors.grey,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: AppColors.primary,
                            ),
                            child: Icon(
                              data['icon'],
                              color: AppColors.white,
                            ),
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'] ?? 'not title',
                                style: TextStyle(
                                  fontSize: AppSizes.fontBase,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                data['category'] ?? 'no category',
                                style: TextStyle(
                                    fontSize: AppSizes.fontSmall,
                                    color: AppColors.black.withOpacity(0.4)),
                              ),
                            ],
                          )
                        ],
                      ),
                      Text(
                        '${formatToRupiah(data['amount']) ?? '0'}',
                        style: TextStyle(
                          fontSize: AppSizes.fontBase,
                          fontWeight: FontWeight.bold,
                          color: data['type'] == 'pengeluaran'
                              ? AppColors.danger
                              : data['type'] == 'pemasukan'
                                  ? AppColors.success
                                  : Colors.black,
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: dataTransaction.length,
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
          );
  }
}
