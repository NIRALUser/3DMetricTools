#ifndef COLORBAR_H
#define COLORBAR_H

// Qt Libraries
#include <QWidget>
#include <QLinearGradient>
#include <QPalette>
#include <QBrush>
#include <QPainter>
#include <QPixmap>
#include <QRect>
#include <QGradientStop>
#include <QGradientStops>

// Other Libraries
#include <iostream>

class colorBar: public QWidget
{
    Q_OBJECT

    public:
        colorBar( QWidget *Qparent = NULL );

        /* Set the size of the color bar
         */
        void setSize( QPoint topLeft , QPoint bottomRight );

        /* init the type of the color bar
         * signed = 5 points and absolute = 3 points
         */
        void initGradientSigned();
        void initGradientAbsolute();

        /* change the position of the color
         */
        void changeCyan( double NewPosition );
        void changeYellow( double NewPosition );
        void changeGreen();

        /* update the color bar
         */
        void updateGradient();

        /* paint the color bar
         */
        void paintEvent(QPaintEvent *);

    private:
        QRect m_Rect;
        QLinearGradient m_Gradient;
        QPixmap *m_Background;

        QGradientStop m_Cyan;
        QGradientStop m_Yellow;
        QGradientStop m_Green;

        int m_ItCyan;
        int m_ItYellow;
        int m_ItGreen;

        QGradientStops m_List;

};


#endif