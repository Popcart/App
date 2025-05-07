import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:popcart/core/colors.dart';
import 'package:popcart/core/widgets/widgets.dart';
import 'package:popcart/gen/assets.gen.dart';
import 'package:popcart/utils/text_styles.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Welcome back!', style: TextStyles.heading),
              AppAssets.icons.chat.svg(),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Here is how your store is performing today.',
            style: TextStyles.subheading,
          ),
          const SizedBox(height: 24),
          Expanded(
            child: ListView(
              children: [
                CustomExpansionTile(
                  title: 'Sales Overview',
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: boxItem(
                              icon: AppAssets.icons.totalSales.svg(),
                              label: 'Total Sales',
                              color: AppColors.lemon,
                              textColor: AppColors.textBlack2,
                              value: '1,800'),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: boxItem(
                              icon: AppAssets.icons.totalRevenue.svg(),
                              label: 'Total Sales',
                              textColor: AppColors.textBlack2,
                              value: '#50m',
                              color: AppColors.blue),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: const FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: const [
                                FlSpot(0, 1),
                                FlSpot(1, 1.5),
                                FlSpot(2, 1.4),
                                FlSpot(3, 3.4),
                                FlSpot(4, 2),
                                FlSpot(5, 2.2),
                                FlSpot(6, 1.8),
                              ],
                              isCurved: true,
                              color: Colors.blue,
                              barWidth: 2,
                              dotData: const FlDotData(show: false),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                CustomExpansionTile(
                  title: 'Live Stream Insights',
                  children: [
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          child: boxItem(
                            textColor: AppColors.white,
                            icon: AppAssets.icons.totalViews.svg(),
                            label: 'Total Views',
                            color: AppColors.boxGrey,
                            value: '1,800',
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          child: boxItem(
                            textColor: AppColors.white,
                            icon: AppAssets.icons.avgWatch.svg(),
                            label: 'Avg. Watch',
                            color: AppColors.boxGrey,
                            value: '1,800',
                          ),
                        ),
                        SizedBox(
                          width: (MediaQuery.of(context).size.width - 48) / 2,
                          child: boxItem(
                            textColor: AppColors.white,
                            icon: AppAssets.icons.engagement.svg(),
                            label: 'Engagements',
                            color: AppColors.boxGrey,
                            value: '1,800',
                          ),
                        ),
                        // Add more boxItem() if needed
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomExpansionTile(
                  title: 'Top Products',
                  children: [
                    TopProductWidget(),
                    TopProductWidget(),
                    TopProductWidget(),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomExpansionTile(
                  title: 'Inventory Alerts',
                  children: [],
                ),
                const SizedBox(
                  height: 10,
                ),
                const CustomExpansionTile(
                  title: 'Ongoing Orders',
                  children: [],
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget boxItem({
    required SvgPicture icon,
    required String label,
    required String value,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Text(value,
              style: TextStyle(
                  color: textColor, fontSize: 32, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class CustomExpansionTile extends StatefulWidget {
  const CustomExpansionTile({
    required this.title,
    required this.children,
    super.key,
  });

  final String title;
  final List<Widget> children;

  @override
  State<CustomExpansionTile> createState() => _CustomExpansionTileState();
}

class _CustomExpansionTileState extends State<CustomExpansionTile>
    with SingleTickerProviderStateMixin {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(
          widget.title,
          style: TextStyles.titleHeading,
        ),
        trailing: AnimatedRotation(
          turns: _expanded ? 0.5 : 0.0,
          duration: const Duration(milliseconds: 200),
          child: AppAssets.icons.expanded.svg(),
        ),
        onExpansionChanged: (expanded) {
          setState(() => _expanded = expanded);
        },
        children: widget.children,
      ),
    );
  }
}
